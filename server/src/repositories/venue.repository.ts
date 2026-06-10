import prisma from '../config/db';
import { Venue, Prisma } from '@prisma/client';

export class VenueRepository {
  async create(data: Prisma.VenueCreateInput): Promise<Venue> {
    return prisma.venue.create({ data });
  }

  async findById(id: string): Promise<Venue | null> {
    return prisma.venue.findUnique({
      where: { id },
    });
  }

  async findAll(filters?: { sportType?: string }): Promise<Venue[]> {
    const where: Prisma.VenueWhereInput = {};
    if (filters?.sportType) {
      where.sportType = {
        equals: filters.sportType,
        mode: 'insensitive',
      };
    }
    return prisma.venue.findMany({
      where,
      orderBy: { name: 'asc' },
    });
  }

  async findAndCountAll(params: {
    sportType?: string;
    skip?: number;
    take?: number;
  }): Promise<{ venues: Venue[]; total: number }> {
    const where: Prisma.VenueWhereInput = {};
    if (params.sportType) {
      where.sportType = {
        equals: params.sportType,
        mode: 'insensitive',
      };
    }

    const [venues, total] = await Promise.all([
      prisma.venue.findMany({
        where,
        skip: params.skip,
        take: params.take,
        orderBy: { name: 'asc' },
      }),
      prisma.venue.count({ where }),
    ]);

    return { venues, total };
  }
}

export const venueRepository = new VenueRepository();
