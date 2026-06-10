import prisma from '../config/db';
import { Waitlist, Prisma } from '@prisma/client';

export class WaitlistRepository {
  async create(data: Prisma.WaitlistUncheckedCreateInput, tx?: Prisma.TransactionClient): Promise<Waitlist> {
    const client = tx || prisma;
    return client.waitlist.create({ data });
  }

  async findById(id: string): Promise<Waitlist | null> {
    return prisma.waitlist.findUnique({
      where: { id },
      include: {
        user: true,
        slot: {
          include: { venue: true },
        },
      },
    });
  }

  async findByUserAndSlot(userId: string, slotId: string): Promise<Waitlist | null> {
    return prisma.waitlist.findUnique({
      where: {
        slotId_userId: { slotId, userId },
      },
    });
  }

  async findFirstForSlot(slotId: string, tx?: Prisma.TransactionClient): Promise<Waitlist | null> {
    const client = tx || prisma;
    return client.waitlist.findFirst({
      where: { slotId },
      orderBy: { createdAt: 'asc' }, // FIFO queue for waitlist
    });
  }

  async findAll(filters?: { userId?: string }): Promise<Waitlist[]> {
    const where: Prisma.WaitlistWhereInput = {};
    if (filters?.userId) {
      where.userId = filters.userId;
    }
    return prisma.waitlist.findMany({
      where,
      include: {
        slot: {
          include: { venue: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async delete(id: string, tx?: Prisma.TransactionClient): Promise<Waitlist> {
    const client = tx || prisma;
    return client.waitlist.delete({
      where: { id },
    });
  }
}

export const waitlistRepository = new WaitlistRepository();
