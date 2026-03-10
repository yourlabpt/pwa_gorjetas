import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { isAdminLike } from './role.util';

@Injectable()
export class RestaurantAccessGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    // No user means public route or unauthenticated; JwtAuthGuard should handle auth.
    if (!user) return true;
    if (isAdminLike(user.role)) return true;

    const restID =
      (request.query?.restID && Number(request.query.restID)) ||
      (request.body?.restID && Number(request.body.restID));

    if (restID && Array.isArray(user.restaurantes)) {
      const allowed = user.restaurantes.map((r: any) => Number(r));
      if (!allowed.includes(restID)) {
        throw new ForbiddenException('Restaurante não autorizado para este usuário');
      }
    }

    return true;
  }
}
