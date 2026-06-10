import { z } from 'zod';

export const createVenueSchema = z.object({
  body: z.object({
    name: z.string().min(1, 'Name is required'),
    sportType: z.string().min(1, 'Sport type is required'),
    address: z.string().min(1, 'Address is required'),
    imageUrl: z.string().url('Invalid image URL').optional().nullable(),
  }),
});

export const getVenueSchema = z.object({
  params: z.object({
    id: z.string().uuid('Invalid venue ID format'),
  }),
});

export const listVenuesSchema = z.object({
  query: z.object({
    sportType: z.string().optional(),
    page: z
      .string()
      .optional()
      .default('1')
      .transform((val) => parseInt(val, 10))
      .refine((val) => !isNaN(val) && val > 0, { message: 'Page must be a positive integer' }),
    limit: z
      .string()
      .optional()
      .default('10')
      .transform((val) => parseInt(val, 10))
      .refine((val) => !isNaN(val) && val > 0 && val <= 100, { message: 'Limit must be between 1 and 100' }),
  }),
});

export const getVenueSlotsSchema = z.object({
  params: z.object({
    id: z.string().uuid('Invalid venue ID format'),
  }),
  query: z.object({
    date: z
      .string()
      .regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format')
      .optional(),
  }),
});
