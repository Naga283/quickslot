import { Router } from 'express';
import { bookingController } from '../controllers/booking.controller';
import { validate } from '../middlewares/validation.middleware';
import { createBookingSchema, deleteBookingSchema, listBookingsSchema } from '../validations/booking.validation';
import { z } from 'zod';

const router = Router();

const getBookingSchema = z.object({
  params: z.object({
    id: z.string().uuid('Invalid booking ID format'),
  }),
});

router.post('/', validate(createBookingSchema), bookingController.createBooking);
router.delete('/:id', validate(deleteBookingSchema), bookingController.cancelBooking);
router.get('/:id', validate(getBookingSchema), bookingController.getBookingById);
router.get('/', validate(listBookingsSchema), bookingController.getBookings);

export default router;
