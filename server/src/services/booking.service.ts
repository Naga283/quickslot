import prisma from '../config/db';
import { bookingRepository, BookingWithRelations } from '../repositories/booking.repository';
import { slotRepository } from '../repositories/slot.repository';
import { userRepository } from '../repositories/user.repository';
import { waitlistRepository } from '../repositories/waitlist.repository';
import { ApiError } from '../utils/api-error';
import { Booking, SlotStatus, Slot } from '@prisma/client';
import { emitSlotUpdated, emitBookingCreated, emitBookingCancelled } from '../utils/socket';

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

    try {
      const booking = await prisma.$transaction(async (tx) => {
        // Acquire row-level lock on the Slot row using SELECT ... FOR UPDATE
        const slots = await tx.$queryRaw<Slot[]>`
          SELECT * FROM "Slot" WHERE id = ${slotId} FOR UPDATE
        `;

        if (!slots || slots.length === 0) {
          throw ApiError.notFound('Slot not found');
        }

        const lockedSlot = slots[0];

        // Verify status under lock
        if (lockedSlot.status === SlotStatus.BOOKED) {
          throw ApiError.conflict('Slot is already booked');
        }

        // Create the booking
        const newBooking = await bookingRepository.create({ userId, slotId }, tx);
        
        // Update slot status to BOOKED
        await tx.slot.update({
          where: { id: slotId },
          data: { status: SlotStatus.BOOKED },
        });

        // Clean up waitlist entry if user was on it
        const waitlistEntry = await tx.waitlist.findUnique({
          where: { slotId_userId: { slotId, userId } },
        });
        if (waitlistEntry) {
          await tx.waitlist.delete({
            where: { id: waitlistEntry.id },
          });
        }

        return newBooking;
      });

      // Broadcast booking details and slot state updates to clients instantly
      emitSlotUpdated(slotId, SlotStatus.BOOKED, slot.venueId);
      emitBookingCreated(booking);

      return booking;
    } catch (error: any) {
      if (error.code === 'P2002') {
        throw ApiError.conflict('Slot is already booked');
      }
      throw error;
    }
  }

  async cancelBooking(bookingId: string): Promise<{ booking: BookingWithRelations; promotedWaitlist: boolean }> {
    const booking = await bookingRepository.findById(bookingId);
    if (!booking) {
      throw ApiError.notFound('Booking not found');
    }

    const slotId = booking.slotId;
    const venueId = booking.slot.venueId;

    const result = await prisma.$transaction(async (tx) => {
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

    // Broadcast booking cancellation and slot status updates to clients instantly
    emitBookingCancelled(bookingId, slotId);
    
    if (result.promotedWaitlist) {
      emitSlotUpdated(slotId, SlotStatus.BOOKED, venueId);
    } else {
      emitSlotUpdated(slotId, SlotStatus.AVAILABLE, venueId);
    }

    return result;
  }

  async getBookingById(id: string): Promise<BookingWithRelations> {
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
