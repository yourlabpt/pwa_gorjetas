import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { randomUUID } from 'crypto';

/**
 * Interceptor that captures request metadata (request ID, IP address, user agent).
 * Attaches these to the request object for use in services.
 */
@Injectable()
export class AuditRequestInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const response = context.switchToHttp().getResponse();

    // Generate unique request ID
    const requestId = randomUUID();
    request.requestId = requestId;
    response.set('X-Request-ID', requestId);

    // Capture IP address
    const ipAddress =
      request.headers['x-forwarded-for'] ||
      request.headers['x-real-ip'] ||
      request.socket.remoteAddress ||
      request.connection.remoteAddress ||
      'unknown';
    request.ipAddress = Array.isArray(ipAddress) ? ipAddress[0] : ipAddress;

    // Capture user agent
    request.userAgent = request.headers['user-agent'] || 'unknown';

    // Record request start time for duration calculation
    const startTime = Date.now();

    return next.handle().pipe(
      tap({
        next: () => {
          const duration = Date.now() - startTime;
          request.requestDuration = duration;
        },
        error: (err) => {
          const duration = Date.now() - startTime;
          request.requestDuration = duration;
          request.requestError = err;
        },
      }),
    );
  }
}
