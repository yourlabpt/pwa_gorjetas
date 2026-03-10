import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UserRole } from '@prisma/client';
import { isAdminLike, isSuperAdmin } from '../auth/role.util';
import * as bcrypt from 'bcryptjs';

const ROLE_MANAGER = ((UserRole as any).GERENTE ||
  (UserRole as any).GESTOR ||
  'GERENTE') as UserRole;

@Injectable()
export class UsersService {
  private readonly passwordHashRounds = Number(
    process.env.PASSWORD_HASH_ROUNDS || '12',
  );

  constructor(private prisma: PrismaService) {}

  private normalizeRoleInput(role: string): string {
    const normalized = String(role || '').trim().toUpperCase();
    if (normalized === 'GESTOR' || normalized === 'GERENTE') return ROLE_MANAGER;
    return normalized;
  }

  private normalizeRoleOutput(role: string): string {
    return role === 'GESTOR' ? 'GERENTE' : role;
  }

  private normalizeUserRoleRecord<T extends { role?: string }>(user: T): T {
    if (!user) return user;
    return {
      ...user,
      role: this.normalizeRoleOutput(String(user.role || '')),
    };
  }

  private readonly userPublicSelect = {
    id: true,
    name: true,
    email: true,
    role: true,
    createdAt: true,
    updatedAt: true,
    restaurantes: {
      select: {
        restID: true,
      },
    },
  } as const;

  async findAll() {
    const users = await this.prisma.user.findMany({
      select: this.userPublicSelect,
      orderBy: { createdAt: 'desc' },
    });
    return users.map((user) => this.normalizeUserRoleRecord(user));
  }

  async findOne(id: number) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: this.userPublicSelect,
    });
    if (!user) throw new NotFoundException('Usuário não encontrado');
    return this.normalizeUserRoleRecord(user);
  }

  async updateRole(id: number, role: string, actor: any) {
    const normalizedRole = this.normalizeRoleInput(role);
    const allowedRoles = new Set([
      'SUPER_ADMIN',
      'ADMIN',
      'SUPERVISOR',
      ROLE_MANAGER,
    ]);
    if (!allowedRoles.has(normalizedRole)) {
      throw new BadRequestException('Role inválida');
    }

    const target = await this.prisma.user.findUnique({
      where: { id },
      select: { id: true, role: true },
    });
    if (!target) throw new NotFoundException('Usuário não encontrado');

    this.assertCanManageTarget(actor, target.id, target.role);

    if (normalizedRole === UserRole.ADMIN && !isSuperAdmin(actor?.role)) {
      throw new ForbiddenException(
        'Apenas SUPER_ADMIN pode promover usuários para Administrador',
      );
    }

    if (normalizedRole === UserRole.SUPER_ADMIN) {
      throw new ForbiddenException(
        'Criação de SUPER_ADMIN é permitida apenas via bootstrap seguro',
      );
    }

    const updated = await this.prisma.user.update({
      where: { id },
      data: { role: normalizedRole as UserRole },
      select: this.userPublicSelect,
    });
    return this.normalizeUserRoleRecord(updated);
  }

  async setRestaurants(id: number, restIDs: number[], actor: any) {
    const user = await this.findOne(id);
    this.assertCanManageTarget(actor, user.id, user.role);

    if (isAdminLike(user.role)) {
      throw new ForbiddenException(
        'Usuários Administrador/SUPER_ADMIN já possuem acesso total',
      );
    }

    return this.prisma.$transaction(async (tx) => {
      await tx.userRestaurant.deleteMany({ where: { userId: id } });
      if (restIDs.length) {
        await tx.userRestaurant.createMany({
          data: restIDs.map((restID) => ({ userId: id, restID })),
        });
      }
      const updated = await tx.user.findUnique({
        where: { id },
        select: this.userPublicSelect,
      });
      return updated ? this.normalizeUserRoleRecord(updated) : updated;
    });
  }

  async deleteUser(id: number, actor: any) {
    const target = await this.prisma.user.findUnique({
      where: { id },
      select: { id: true, role: true },
    });
    if (!target) throw new NotFoundException('Usuário não encontrado');

    this.assertCanManageTarget(actor, target.id, target.role);

    await this.prisma.user.delete({ where: { id } });
    return { success: true };
  }

  async resetPassword(id: number, newPassword: string, actor: any) {
    const target = await this.prisma.user.findUnique({
      where: { id },
      select: { id: true, role: true },
    });
    if (!target) throw new NotFoundException('Usuário não encontrado');

    this.assertCanManageTarget(actor, target.id, target.role);

    const passwordHash = await bcrypt.hash(
      String(newPassword || ''),
      this.passwordHashRounds,
    );

    await this.prisma.user.update({
      where: { id },
      data: { passwordHash },
    });

    return { success: true };
  }

  private assertCanManageTarget(
    actor: any,
    targetUserId: number,
    targetRole: UserRole,
  ) {
    if (!isAdminLike(actor?.role)) {
      throw new ForbiddenException('Acesso negado');
    }

    if (Number(actor?.userId) === Number(targetUserId)) {
      throw new ForbiddenException('Não é permitido alterar/deletar seu próprio usuário');
    }

    if (targetRole === UserRole.SUPER_ADMIN && !isSuperAdmin(actor?.role)) {
      throw new ForbiddenException(
        'Apenas SUPER_ADMIN pode gerenciar contas SUPER_ADMIN',
      );
    }

    if (targetRole === UserRole.ADMIN && !isSuperAdmin(actor?.role)) {
      throw new ForbiddenException(
        'Apenas SUPER_ADMIN pode gerenciar contas Administrador',
      );
    }
  }
}
