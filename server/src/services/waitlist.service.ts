import { waitlistRepository } from '../repositories/waitlist.repository';
import { slotRepository } from '../repositories/slot.repository';
import { userRepository } from '../repositories/user.repository';
import { bookingRepository } from '../repositories/booking.repository';
import { ApiError } from '../utils/api-error';
import { Waitlist, SlotStatus } from '@prisma/client';

export class WaitlistService {
  async joinWaitlist(userId: string, slotId: string): Promise<Waitlist> {
    const user = await userRepository.findById(userId);
    if (!user) {
      throw ApiError.notFound('User not found');
    }

    const slot = await slotRepository.findById(slotId);
    if (!slot) {
      throw ApiError.notFound('Slot not found');
    }

    if (slot.status === SlotStatus.AVAILABLE) {
      throw ApiError.badRequest('Slot is available. Please book it directly.');
    }

    // Check if the user is already booked for this slot
    const booking = await bookingRepository.findBySlotId(slotId);
    if (booking && booking.userId === userId) {
      throw ApiError.conflict('User is already booked for this slot');
    }

    // Check if the user is already waitlisted for this slot
    const existing = await waitlistRepository.findByUserAndSlot(userId, slotId);
    if (existing) {
      throw ApiError.conflict('User is already on the waitlist for this slot');
    }

    return waitlistRepository.create({ userId, slotId });
  }

  async leaveWaitlist(waitlistId: string): Promise<Waitlist> {
    const entry = await waitlistRepository.findById(waitlistId);
    if (!entry) {
      throw ApiError.notFound('Waitlist entry not found');
    }
    return waitlistRepository.delete(waitlistId);
  }

  async getWaitlist(filters?: { userId?: string }): Promise<Waitlist[]> {
    if (filters?.userId) {
      const user = await userRepository.findById(filters.userId);
      if (!user) {
        throw ApiError.notFound('User not found');
      }
    }
    return waitlistRepository.findAll(filters);
  }
}

export const waitlistService = new WaitlistService();
