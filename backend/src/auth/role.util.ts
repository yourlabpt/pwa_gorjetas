import { ForbiddenException } from '@nestjs/common';
import { UserRole } from '@prisma/client';

export function isSuperAdmin(role?: UserRole | string | null): boolean {
  return role === UserRole.SUPER_ADMIN;
}

export function isAdminLike(role?: UserRole | string | null): boolean {
  return role === UserRole.ADMIN || role === UserRole.SUPER_ADMIN;
}

export function canManageRestaurants(role?: UserRole | string | null): boolean {
  return role === UserRole.SUPERVISOR || isAdminLike(role);
}

export function isVisualizador(role?: UserRole | string | null): boolean {
  return role === UserRole.VISUALIZADOR;
}

export function isReadOnly(role?: UserRole | string | null): boolean {
  return isVisualizador(role);
}

export function hasGlobalReadAccess(role?: UserRole | string | null): boolean {
  return isAdminLike(role) || isVisualizador(role);
}

export function assertCanWrite(user?: { role?: string } | null): void {
  if (isReadOnly(user?.role)) {
    throw new ForbiddenException(
      'Utilizadores Visualizador não podem alterar dados',
    );
  }
}
