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
  }),
});
