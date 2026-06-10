import { Request, Response, NextFunction } from 'express';
import { venueService } from '../services/venue.service';
import { successResponse } from '../utils/response';

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
      const { sportType } = req.query;
      const venues = await venueService.getAllVenues({ sportType: sportType as string });
      successResponse(res, venues, 'Venues retrieved successfully');
    } catch (error) {
      next(error);
    }
  }
}

export const venueController = new VenueController();
