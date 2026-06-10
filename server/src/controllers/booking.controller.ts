import { Request, Response, NextFunction } from 'express';
import { bookingService } from '../services/booking.service';
import { successResponse } from '../utils/response';

export class BookingController {
  async createBooking(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { userId, slotId } = req.body;
      const booking = await bookingService.createBooking(userId, slotId);
      successResponse(res, booking, 'Slot booked successfully', 201);
    } catch (error) {
      next(error);
    }
  }

  async cancelBooking(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const result = await bookingService.cancelBooking(id);
      
      const message = result.promotedWaitlist
        ? 'Booking cancelled and next waitlisted user promoted successfully'
        : 'Booking cancelled successfully';

      successResponse(res, result.booking, message);
    } catch (error) {
      next(error);
    }
  }

  async getBookingById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const booking = await bookingService.getBookingById(req.params.id);
      successResponse(res, booking, 'Booking retrieved successfully');
    } catch (error) {
      next(error);
    }
  }

  async getBookings(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { userId } = req.query;
      const bookings = await bookingService.getBookings({ userId: userId as string });
      successResponse(res, bookings, 'Bookings retrieved successfully');
    } catch (error) {
      next(error);
    }
  }

  async getBookingsForUser(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const bookings = await bookingService.getBookings({ userId: id });
      successResponse(res, bookings, 'User bookings retrieved successfully');
    } catch (error) {
      next(error);
    }
  }
}

export const bookingController = new BookingController();
