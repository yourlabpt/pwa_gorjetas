import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UserRole } from '@prisma/client';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    return this.prisma.user.findMany({
      include: { restaurantes: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: number) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: { restaurantes: true },
    });
    if (!user) throw new NotFoundException('Usuário não encontrado');
    return user;
  }

  async updateRole(id: number, role: UserRole) {
    return this.prisma.user.update({
      where: { id },
      data: { role },
      include: { restaurantes: true },
    });
  }

  async setRestaurants(id: number, restIDs: number[]) {
    const user = await this.findOne(id);
    if (user.role === UserRole.ADMIN) {
      throw new ForbiddenException('Admin já tem acesso total');
    }
    return this.prisma.$transaction(async (tx) => {
      await tx.userRestaurant.deleteMany({ where: { userId: id } });
      if (restIDs.length) {
        await tx.userRestaurant.createMany({
          data: restIDs.map((restID) => ({ userId: id, restID })),
        });
      }
      return tx.user.findUnique({
        where: { id },
        include: { restaurantes: true },
      });
    });
  }
}
