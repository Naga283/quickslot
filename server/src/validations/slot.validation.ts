import { z } from 'zod';

export const listSlotsSchema = z.object({
  query: z.object({
    venueId: z.string().uuid('Invalid venue ID format'),
    date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format').optional(),
  }),
});

export const generateSlotsSchema = z.object({
  body: z.object({
    venueId: z.string().uuid('Invalid venue ID format'),
    days: z.number().int().min(1).max(90).default(30),
  }),
});
