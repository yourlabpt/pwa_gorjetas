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
