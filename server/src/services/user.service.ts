import { userRepository } from '../repositories/user.repository';
import { ApiError } from '../utils/api-error';
import { User, Prisma } from '@prisma/client';

export class UserService {
  async createUser(data: Prisma.UserCreateInput): Promise<User> {
    const existing = await userRepository.findByEmail(data.email);
    if (existing) {
      throw ApiError.conflict('Email is already registered');
    }
    return userRepository.create(data);
  }

  async getUserById(id: string): Promise<User> {
    const user = await userRepository.findById(id);
    if (!user) {
      throw ApiError.notFound('User not found');
    }
    return user;
  }
}

export const userService = new UserService();
