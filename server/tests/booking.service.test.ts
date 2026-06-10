import { SlotStatus } from '@prisma/client';
import { bookingService } from '../src/services/booking.service';
import prisma from '../src/config/db';
import { bookingRepository } from '../src/repositories/booking.repository';
import { slotRepository } from '../src/repositories/slot.repository';
import { userRepository } from '../src/repositories/user.repository';
import { ApiError } from '../src/utils/api-error';

jest.mock('../src/config/db', () => ({
  __esModule: true,
  default: {
    $transaction: jest.fn(),
  },
}));

jest.mock('../src/repositories/booking.repository', () => ({
  bookingRepository: {
    create: jest.fn(),
    findById: jest.fn(),
    delete: jest.fn(),
    findAll: jest.fn(),
  },
}));

jest.mock('../src/repositories/slot.repository', () => ({
  slotRepository: {
    findById: jest.fn(),
  },
}));

jest.mock('../src/repositories/user.repository', () => ({
  userRepository: {
    findById: jest.fn(),
  },
}));

jest.mock('../src/repositories/waitlist.repository', () => ({
  waitlistRepository: {
    findFirstForSlot: jest.fn(),
    delete: jest.fn(),
  },
}));

jest.mock('../src/utils/socket', () => ({
  emitSlotUpdated: jest.fn(),
  emitBookingCreated: jest.fn(),
  emitBookingCancelled: jest.fn(),
  emitWaitlistPromoted: jest.fn(),
}));

const mockedPrisma = prisma as unknown as {
  $transaction: jest.Mock;
};

const user = { id: 'user-1' };
const slot = {
  id: 'slot-1',
  venueId: 'venue-1',
  status: SlotStatus.AVAILABLE,
};

describe('BookingService.createBooking', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    (userRepository.findById as jest.Mock).mockResolvedValue(user);
    (slotRepository.findById as jest.Mock).mockResolvedValue(slot);
  });

  it('creates a booking and marks the slot as booked inside a transaction', async () => {
    const tx = {
      $queryRaw: jest.fn().mockResolvedValue([slot]),
      slot: { update: jest.fn().mockResolvedValue({ ...slot, status: SlotStatus.BOOKED }) },
      waitlist: {
        findUnique: jest.fn().mockResolvedValue(null),
        delete: jest.fn(),
      },
    };
    const booking = {
      id: 'booking-1',
      userId: user.id,
      slotId: slot.id,
      createdAt: new Date(),
    };

    mockedPrisma.$transaction.mockImplementation((callback) => callback(tx));
    (bookingRepository.create as jest.Mock).mockResolvedValue(booking);

    await expect(bookingService.createBooking(user.id, slot.id)).resolves.toEqual(booking);

    expect(tx.$queryRaw).toHaveBeenCalledTimes(1);
    expect(bookingRepository.create).toHaveBeenCalledWith({ userId: user.id, slotId: slot.id }, tx);
    expect(tx.slot.update).toHaveBeenCalledWith({
      where: { id: slot.id },
      data: { status: SlotStatus.BOOKED },
    });
  });

  it('rejects when the slot is already booked before the transaction', async () => {
    (slotRepository.findById as jest.Mock).mockResolvedValue({
      ...slot,
      status: SlotStatus.BOOKED,
    });

    await expect(bookingService.createBooking(user.id, slot.id)).rejects.toMatchObject({
      statusCode: 409,
      message: 'Slot is already booked',
    });

    expect(mockedPrisma.$transaction).not.toHaveBeenCalled();
  });

  it('allows only one concurrent booking for the same slot', async () => {
    let lockedStatus: SlotStatus = SlotStatus.AVAILABLE;
    let createdCount = 0;
    const tx = {
      $queryRaw: jest.fn(async () => [{ ...slot, status: lockedStatus }]),
      slot: {
        update: jest.fn(async () => {
          lockedStatus = SlotStatus.BOOKED;
          return { ...slot, status: SlotStatus.BOOKED };
        }),
      },
      waitlist: {
        findUnique: jest.fn().mockResolvedValue(null),
        delete: jest.fn(),
      },
    };

    let transactionQueue = Promise.resolve();
    mockedPrisma.$transaction.mockImplementation((callback) => {
      const run = transactionQueue.then(() => callback(tx));
      transactionQueue = run.catch(() => undefined);
      return run;
    });
    (bookingRepository.create as jest.Mock).mockImplementation(async () => {
      createdCount += 1;
      return {
        id: `booking-${createdCount}`,
        userId: user.id,
        slotId: slot.id,
        createdAt: new Date(),
      };
    });

    const results = await Promise.allSettled([
      bookingService.createBooking(user.id, slot.id),
      bookingService.createBooking(user.id, slot.id),
    ]);

    expect(results.filter((result) => result.status === 'fulfilled')).toHaveLength(1);
    const rejected = results.find(
      (result) => result.status === 'rejected',
    ) as PromiseRejectedResult;
    expect(rejected.reason).toBeInstanceOf(ApiError);
    expect(rejected.reason.statusCode).toBe(409);
    expect(bookingRepository.create).toHaveBeenCalledTimes(1);
  });
});
