import { Request, Response, NextFunction } from 'express';
import { venueService } from '../services/venue.service';
import { slotService } from '../services/slot.service';
import { successResponse, paginatedResponse } from '../utils/response';

export class VenueController {
  async createVenue(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const venue = await venueService.createVenue(req.body);
      successResponse(res, venue, 'Venue created successfully', 201);
    } catch (error) {
      next(error);
    }
  }

  async getVenueById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const venue = await venueService.getVenueById(req.params.id);
      successResponse(res, venue, 'Venue retrieved successfully');
    } catch (error) {
      next(error);
    }
  }

  async getAllVenues(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { sportType, page, limit } = req.query;
      
      const pageNum = page as unknown as number;
      const limitNum = limit as unknown as number;
      
      const { venues, total } = await venueService.getPaginatedVenues({
        sportType: sportType as string,
        page: pageNum,
        limit: limitNum,
      });

      paginatedResponse(res, venues, pageNum, limitNum, total, 'Venues retrieved successfully');
    } catch (error) {
      next(error);
    }
  }

  async getVenueSlots(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const { date } = req.query;
      
      const slots = await slotService.getSlotsByVenueAndDate(id, date as string);
      successResponse(res, slots, 'Venue slots retrieved successfully');
    } catch (error) {
      next(error);
    }
  }
}

export const venueController = new VenueController();
