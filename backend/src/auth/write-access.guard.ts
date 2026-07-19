import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { isReadOnly } from './role.util';

const WRITE_WHITELIST: Array<{ method: string; pathSuffix: string }> = [
  { method: 'POST', pathSuffix: '/auth/login' },
  { method: 'POST', pathSuffix: '/auth/logout' },
  { method: 'POST', pathSuffix: '/faturamento-diario/compute' },
];

@Injectable()
export class WriteAccessGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) return true;

    const method = String(request.method || 'GET').toUpperCase();
    if (['GET', 'HEAD', 'OPTIONS'].includes(method)) return true;

    const path = String(request.path || request.url || '').split('?')[0];
    if (
      WRITE_WHITELIST.some(
        (entry) => entry.method === method && path.endsWith(entry.pathSuffix),
      )
    ) {
      return true;
    }

    if (isReadOnly(user.role)) {
      throw new ForbiddenException(
        'Utilizadores Visualizador não podem alterar dados',
      );
    }

    return true;
  }
}
