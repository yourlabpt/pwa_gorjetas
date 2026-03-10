import { ForbiddenException } from '@nestjs/common';
import { isAdminLike } from './role.util';

export function getAllowedRestaurantes(user: any): number[] | undefined {
  if (!user) return [];
  if (isAdminLike(user.role)) return undefined;
  return (user.restaurantes || []).map((r: any) => Number(r.restID ?? r));
}

export function assertRestaurantAccess(user: any, restID?: number | null) {
  if (!restID) return;
  const allowed = getAllowedRestaurantes(user);
  if (allowed && !allowed.includes(Number(restID))) {
    throw new ForbiddenException('Restaurante não autorizado para este usuário');
  }
}
