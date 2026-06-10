import prisma from '../config/db';
import { bookingRepository } from '../repositories/booking.repository';
import { slotRepository } from '../repositories/slot.repository';
import { userRepository } from '../repositories/user.repository';
import { waitlistRepository } from '../repositories/waitlist.repository';
import { ApiError } from '../utils/api-error';
import { Booking, SlotStatus } from '@prisma/client';

export class BookingService {
  async createBooking(userId: string, slotId: string): Promise<Booking> {
    const user = await userRepository.findById(userId);
    if (!user) {
      throw ApiError.notFound('User not found');
    }

    const slot = await slotRepository.findById(slotId);
    if (!slot) {
      throw ApiError.notFound('Slot not found');
    }

    if (slot.status === SlotStatus.BOOKED) {
      throw ApiError.conflict('Slot is already booked');
    }

    return prisma.$transaction(async (tx) => {
      const booking = await bookingRepository.create({ userId, slotId }, tx);
      
      await tx.slot.update({
        where: { id: slotId },
        data: { status: SlotStatus.BOOKED },
      });

      const waitlistEntry = await tx.waitlist.findUnique({
        where: { slotId_userId: { slotId, userId } },
      });
      if (waitlistEntry) {
        await tx.waitlist.delete({
          where: { id: waitlistEntry.id },
        });
      }

      return booking;
    });
  }

  async cancelBooking(bookingId: string): Promise<{ booking: Booking; promotedWaitlist: boolean }> {
    const booking = await bookingRepository.findById(bookingId);
    if (!booking) {
      throw ApiError.notFound('Booking not found');
    }

    const slotId = booking.slotId;

    return prisma.$transaction(async (tx) => {
      await bookingRepository.delete(bookingId, tx);

      const nextInLine = await waitlistRepository.findFirstForSlot(slotId, tx);

      if (nextInLine) {
        await bookingRepository.create({
          userId: nextInLine.userId,
          slotId: slotId,
        }, tx);

        await waitlistRepository.delete(nextInLine.id, tx);

        return { booking, promotedWaitlist: true };
      } else {
        await tx.slot.update({
          where: { id: slotId },
          data: { status: SlotStatus.AVAILABLE },
        });
        return { booking, promotedWaitlist: false };
      }
    });
  }

  async getBookingById(id: string): Promise<Booking> {
    const booking = await bookingRepository.findById(id);
    if (!booking) {
      throw ApiError.notFound('Booking not found');
    }
    return booking;
  }

  async getBookings(filters?: { userId?: string }): Promise<Booking[]> {
    if (filters?.userId) {
      const user = await userRepository.findById(filters.userId);
      if (!user) {
        throw ApiError.notFound('User not found');
      }
    }
    return bookingRepository.findAll(filters);
  }
}

export const bookingService = new BookingService();
