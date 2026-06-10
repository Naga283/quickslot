import { slotRepository } from '../repositories/slot.repository';
import { venueRepository } from '../repositories/venue.repository';
import { ApiError } from '../utils/api-error';
import { Slot, SlotStatus } from '@prisma/client';

export class SlotService {
  async getSlotsByVenueAndDate(venueId: string, dateStr?: string): Promise<Slot[]> {
    const venue = await venueRepository.findById(venueId);
    if (!venue) {
      throw ApiError.notFound('Venue not found');
    }

    let date: Date | undefined = undefined;
    if (dateStr) {
      const [year, month, day] = dateStr.split('-').map(Number);
      date = new Date(Date.UTC(year, month - 1, day));
    }

    return slotRepository.findByVenueAndDate(venueId, date);
  }

  async generateSlots(venueId: string, days = 30): Promise<number> {
    const venue = await venueRepository.findById(venueId);
    if (!venue) {
      throw ApiError.notFound('Venue not found');
    }

    const slotsToCreate: any[] = [];
    const today = new Date();

    for (let dayOffset = 0; dayOffset < days; dayOffset++) {
      const currentDate = new Date(Date.UTC(today.getFullYear(), today.getMonth(), today.getDate() + dayOffset));

      for (let hour = 6; hour < 22; hour++) {
        const startTime = new Date(currentDate);
        startTime.setUTCHours(hour, 0, 0, 0);

        const endTime = new Date(currentDate);
        endTime.setUTCHours(hour + 1, 0, 0, 0);

        slotsToCreate.push({
          venueId,
          date: currentDate,
          startTime,
          endTime,
          status: SlotStatus.AVAILABLE,
        });
      }
    }

    const result = await slotRepository.createMany(slotsToCreate);
    return result.count;
  }
}

export const slotService = new SlotService();
