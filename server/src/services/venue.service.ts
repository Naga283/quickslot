import { venueRepository } from '../repositories/venue.repository';
import { ApiError } from '../utils/api-error';
import { Venue, Prisma } from '@prisma/client';

export class VenueService {
  async createVenue(data: Prisma.VenueCreateInput): Promise<Venue> {
    return venueRepository.create(data);
  }

  async getVenueById(id: string): Promise<Venue> {
    const venue = await venueRepository.findById(id);
    if (!venue) {
      throw ApiError.notFound('Venue not found');
    }
    return venue;
  }

  async getAllVenues(filters?: { sportType?: string }): Promise<Venue[]> {
    return venueRepository.findAll(filters);
  }

  async getPaginatedVenues(params: {
    sportType?: string;
    page: number;
    limit: number;
  }): Promise<{ venues: Venue[]; total: number }> {
    const skip = (params.page - 1) * params.limit;
    const take = params.limit;
    return venueRepository.findAndCountAll({
      sportType: params.sportType,
      skip,
      take,
    });
  }
}

export const venueService = new VenueService();
