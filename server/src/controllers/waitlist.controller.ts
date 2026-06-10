import { Request, Response, NextFunction } from 'express';
import { waitlistService } from '../services/waitlist.service';
import { successResponse } from '../utils/response';

export class WaitlistController {
  async joinWaitlist(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { userId, slotId } = req.body;
      const entry = await waitlistService.joinWaitlist(userId, slotId);
      successResponse(res, entry, 'Joined waitlist successfully', 201);
    } catch (error) {
      next(error);
    }
  }

  async leaveWaitlist(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const entry = await waitlistService.leaveWaitlist(id);
      successResponse(res, entry, 'Left waitlist successfully');
    } catch (error) {
      next(error);
    }
  }

  async getWaitlist(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { userId } = req.query;
      const entries = await waitlistService.getWaitlist({ userId: userId as string });
      successResponse(res, entries, 'Waitlist entries retrieved successfully');
    } catch (error) {
      next(error);
    }
  }
}

export const waitlistController = new WaitlistController();
