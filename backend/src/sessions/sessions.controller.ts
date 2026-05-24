import { Controller, Get, UseGuards } from '@nestjs/common';
import { SessionsService } from './sessions.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';

@Controller('sessions')
@UseGuards(JwtAuthGuard)
export class SessionsController {
  constructor(private readonly sessionsService: SessionsService) {}

  /**
   * Get all active user sessions (SUPER_ADMIN only)
   * Note: Authorization check is done in the service or via a guard
   */
  @Get('active')
  async getActiveSessions(@CurrentUser() user: any) {
    // Only SUPER_ADMIN can access all sessions
    if (user.role !== 'SUPER_ADMIN') {
      return {
        error: 'Only SUPER_ADMIN can view all active sessions',
        statusCode: 403,
      };
    }

    const sessions = await this.sessionsService.getActiveSessions();
    return {
      total: sessions.length,
      sessions: sessions.map((session) => ({
        id: session.id,
        user: session.user,
        loginTime: session.loginTime,
        lastActivity: session.lastActivity,
        ipAddress: session.ipAddress,
        userAgent: session.userAgent,
        duration: Date.now() - session.loginTime.getTime(),
      })),
    };
  }

  /**
   * Get current user's sessions (their own)
   */
  @Get('my-sessions')
  async getCurrentUserSessions(@CurrentUser() user: any) {
    const sessions = await this.sessionsService.getUserSessions(user.userId);
    return {
      total: sessions.length,
      sessions: sessions.map((session) => ({
        id: session.id,
        loginTime: session.loginTime,
        lastActivity: session.lastActivity,
        ipAddress: session.ipAddress,
        userAgent: session.userAgent,
        duration: Date.now() - session.loginTime.getTime(),
        isActive: session.logoutTime === null,
      })),
    };
  }
}
