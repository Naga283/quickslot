import { z } from 'zod';

export const createBookingSchema = z.object({
  body: z.object({
    userId: z.string().uuid('Invalid user ID format'),
    slotId: z.string().uuid('Invalid slot ID format'),
  }),
});

export const deleteBookingSchema = z.object({
  params: z.object({
    id: z.string().uuid('Invalid booking ID format'),
  }),
});

export const listBookingsSchema = z.object({
  query: z.object({
    userId: z.string().uuid('Invalid user ID format').optional(),
  }),
});

export const createWaitlistSchema = z.object({
  body: z.object({
    userId: z.string().uuid('Invalid user ID format'),
    slotId: z.string().uuid('Invalid slot ID format'),
  }),
});

export const deleteWaitlistSchema = z.object({
  params: z.object({
    id: z.string().uuid('Invalid waitlist ID format'),
  }),
});
