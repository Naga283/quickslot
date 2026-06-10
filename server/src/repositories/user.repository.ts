import prisma from '../config/db';
import { User, Prisma } from '@prisma/client';

export class UserRepository {
  async create(data: Prisma.UserCreateInput): Promise<User> {
    return prisma.user.create({ data });
  }

  async findById(id: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { id },
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { email },
    });
  }

  async findByEmailOrName(username: string): Promise<User | null> {
    return prisma.user.findFirst({
      where: {
        OR: [{ email: username }, { name: username }],
      },
    });
  }
}

export const userRepository = new UserRepository();
