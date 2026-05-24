import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SessionsService {
  private readonly logger = new Logger(SessionsService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Create a new user session on login
   */
  async createSession(
    userId: number,
    ipAddress?: string,
    userAgent?: string,
  ) {
    try {
      const session = await this.prisma.userSession.create({
        data: {
          userId,
          ipAddress,
          userAgent,
          loginTime: new Date(),
          lastActivity: new Date(),
        },
      });
      this.logger.debug(`Session created for user ${userId}: ${session.id}`);
      return session;
    } catch (error) {
      this.logger.error(
        `Failed to create session for user ${userId}`,
        error,
      );
      throw error;
    }
  }

  /**
   * Update last activity timestamp for a session
   */
  async updateLastActivity(sessionId: number) {
    try {
      return await this.prisma.userSession.update({
        where: { id: sessionId },
        data: { lastActivity: new Date() },
      });
    } catch (error) {
      // Session might not exist, which is fine
      this.logger.debug(`Could not update session ${sessionId}`);
    }
  }

  /**
   * Close a user session on logout
   */
  async closeSession(sessionId?: number, userId?: number) {
    try {
      if (sessionId) {
        return await this.prisma.userSession.update({
          where: { id: sessionId },
          data: { logoutTime: new Date() },
        });
      }
      if (userId) {
        // Close the most recent active session for this user
        return await this.prisma.userSession.updateMany({
          where: {
            userId,
            logoutTime: null,
          },
          data: { logoutTime: new Date() },
        });
      }
    } catch (error) {
      this.logger.error(
        `Failed to close session (sessionId: ${sessionId}, userId: ${userId})`,
        error,
      );
      throw error;
    }
  }

  /**
   * Get all active user sessions
   * Returns sessions that are logged in (logoutTime is null)
   */
  async getActiveSessions() {
    try {
      return await this.prisma.userSession.findMany({
        where: { logoutTime: null },
        include: {
          user: {
            select: {
              id: true,
              email: true,
              name: true,
              role: true,
            },
          },
        },
        orderBy: { loginTime: 'desc' },
      });
    } catch (error) {
      this.logger.error('Failed to retrieve active sessions', error);
      throw error;
    }
  }

  /**
   * Get sessions for a specific user
   */
  async getUserSessions(userId: number, includeInactive: boolean = false) {
    try {
      const where: any = { userId };
      if (!includeInactive) {
        where.logoutTime = null;
      }

      return await this.prisma.userSession.findMany({
        where,
        orderBy: { loginTime: 'desc' },
      });
    } catch (error) {
      this.logger.error(`Failed to retrieve sessions for user ${userId}`, error);
      throw error;
    }
  }

  /**
   * Get session details by ID
   */
  async getSessionById(sessionId: number) {
    try {
      return await this.prisma.userSession.findUnique({
        where: { id: sessionId },
        include: {
          user: {
            select: {
              id: true,
              email: true,
              name: true,
              role: true,
            },
          },
        },
      });
    } catch (error) {
      this.logger.error(`Failed to retrieve session ${sessionId}`, error);
      throw error;
    }
  }

  /**
   * Clean up old inactive sessions (older than specified days)
   */
  async cleanupOldSessions(daysToKeep: number = 30) {
    try {
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - daysToKeep);

      const result = await this.prisma.userSession.deleteMany({
        where: {
          logoutTime: {
            lt: cutoffDate,
          },
        },
      });

      this.logger.debug(
        `Cleaned up ${result.count} old sessions (older than ${daysToKeep} days)`,
      );
      return result;
    } catch (error) {
      this.logger.error('Failed to cleanup old sessions', error);
      throw error;
    }
  }
}
