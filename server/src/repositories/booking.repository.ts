import prisma from '../config/db';
import { Booking, Prisma } from '@prisma/client';

export type BookingWithRelations = Prisma.BookingGetPayload<{
  include: {
    user: true;
    slot: {
      include: { venue: true };
    };
  };
}>;

export class BookingRepository {
  async create(data: Prisma.BookingUncheckedCreateInput, tx?: Prisma.TransactionClient): Promise<Booking> {
    const client = tx || prisma;
    return client.booking.create({ data });
  }

  async findById(id: string): Promise<BookingWithRelations | null> {
    return prisma.booking.findUnique({
      where: { id },
      include: {
        user: true,
        slot: {
          include: { venue: true },
        },
      },
    });
  }

  async findBySlotId(slotId: string): Promise<Booking | null> {
    return prisma.booking.findUnique({
      where: { slotId },
    });
  }

  async findAll(filters?: { userId?: string }): Promise<Booking[]> {
    const where: Prisma.BookingWhereInput = {};
    if (filters?.userId) {
      where.userId = filters.userId;
    }
    return prisma.booking.findMany({
      where,
      include: {
        slot: {
          include: { venue: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async delete(id: string, tx?: Prisma.TransactionClient): Promise<Booking> {
    const client = tx || prisma;
    return client.booking.delete({
      where: { id },
    });
  }
}

export const bookingRepository = new BookingRepository();
