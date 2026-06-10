import { Router } from 'express';
import userRoutes from './user.routes';
import venueRoutes from './venue.routes';
import slotRoutes from './slot.routes';
import bookingRoutes from './booking.routes';
import waitlistRoutes from './waitlist.routes';

const router = Router();

router.use('/users', userRoutes);
router.use('/venues', venueRoutes);
router.use('/slots', slotRoutes);
router.use('/bookings', bookingRoutes);
router.use('/waitlists', waitlistRoutes);

export default router;
