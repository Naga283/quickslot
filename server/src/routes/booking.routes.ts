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

/**
 * @openapi
 * /api/bookings:
 *   post:
 *     summary: Create a booking for a slot
 *     tags:
 *       - Bookings
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - slotId
 *             properties:
 *               userId:
 *                 type: string
 *                 format: uuid
 *                 example: "123e4567-e89b-12d3-a456-426614174000"
 *               slotId:
 *                 type: string
 *                 format: uuid
 *                 example: "987f6543-e21b-32d1-b654-526614174999"
 *     responses:
 *       201:
 *         description: Slot booked successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 message:
 *                   type: string
 *                   example: Slot booked successfully
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                       format: uuid
 *                     userId:
 *                       type: string
 *                       format: uuid
 *                     slotId:
 *                       type: string
 *                       format: uuid
 *                     createdAt:
 *                       type: string
 *                       format: date-time
 *       400:
 *         description: Validation error
 *       409:
 *         description: Slot already booked
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: error
 *                 statusCode:
 *                   type: integer
 *                   example: 409
 *                 message:
 *                   type: string
 *                   example: Slot is already booked
 */
router.post('/', validate(createBookingSchema), bookingController.createBooking);

/**
 * @openapi
 * /api/bookings/{id}:
 *   delete:
 *     summary: Cancel a booking
 *     description: Cancel a booking. If there are users on the waitlist for the slot, the oldest waitlisted user is automatically promoted to booked, keeping the slot status booked. Otherwise, the slot is set back to available.
 *     tags:
 *       - Bookings
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: The booking ID to cancel
 *     responses:
 *       200:
 *         description: Booking cancelled successfully (and slot released or next user promoted)
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 message:
 *                   type: string
 *                   example: Booking cancelled and next waitlisted user promoted successfully
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                       format: uuid
 *                     userId:
 *                       type: string
 *                       format: uuid
 *                     slotId:
 *                       type: string
 *                       format: uuid
 *       404:
 *         description: Booking not found
 */
router.delete('/:id', validate(deleteBookingSchema), bookingController.cancelBooking);

router.get('/:id', validate(getBookingSchema), bookingController.getBookingById);
router.get('/', validate(listBookingsSchema), bookingController.getBookings);

export default router;
