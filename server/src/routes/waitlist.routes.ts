import { Router } from 'express';
import { waitlistController } from '../controllers/waitlist.controller';
import { validate } from '../middlewares/validation.middleware';
import { createWaitlistSchema, deleteWaitlistSchema } from '../validations/booking.validation';
import { z } from 'zod';

const router = Router();

const listWaitlistsSchema = z.object({
  query: z.object({
    userId: z.string().uuid('Invalid user ID format').optional(),
  }),
});

router.post('/', validate(createWaitlistSchema), waitlistController.joinWaitlist);
router.delete('/:id', validate(deleteWaitlistSchema), waitlistController.leaveWaitlist);
router.get('/', validate(listWaitlistsSchema), waitlistController.getWaitlist);

export default router;
