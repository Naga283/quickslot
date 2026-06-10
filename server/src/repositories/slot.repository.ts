import prisma from '../config/db';
import { Slot, SlotStatus, Prisma } from '@prisma/client';

export class SlotRepository {
  async create(data: Prisma.SlotUncheckedCreateInput): Promise<Slot> {
    return prisma.slot.create({ data });
  }

  async createMany(data: Prisma.SlotUncheckedCreateInput[]): Promise<Prisma.BatchPayload> {
    return prisma.slot.createMany({ data });
  }

  async findById(id: string): Promise<Slot | null> {
    return prisma.slot.findUnique({
      where: { id },
      include: { venue: true },
    });
  }

  async findByVenueAndDate(venueId: string, date?: Date): Promise<Slot[]> {
    const where: Prisma.SlotWhereInput = { venueId };
    if (date) {
      where.date = date;
    }
    return prisma.slot.findMany({
      where,
      orderBy: { startTime: 'asc' },
    });
  }

  async updateStatus(id: string, status: SlotStatus): Promise<Slot> {
    return prisma.slot.update({
      where: { id },
      data: { status },
    });
  }
}

export const slotRepository = new SlotRepository();
