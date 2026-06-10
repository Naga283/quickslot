import { Request, Response, NextFunction } from 'express';
import { slotService } from '../services/slot.service';
import { successResponse } from '../utils/response';

export class SlotController {
  async getSlots(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { venueId, date } = req.query;
      const slots = await slotService.getSlotsByVenueAndDate(
        venueId as string,
        date as string
      );
      successResponse(res, slots, 'Slots retrieved successfully');
    } catch (error) {
      next(error);
    }
  }

  async generateSlots(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { venueId, days } = req.body;
      const count = await slotService.generateSlots(venueId, days);
      successResponse(res, { count }, `Successfully generated slots for the next ${days} days`, 201);
    } catch (error) {
      next(error);
    }
  }
}

export const slotController = new SlotController();
