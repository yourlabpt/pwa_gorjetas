import {
  Controller,
  Get,
  Query,
  Param,
  ParseIntPipe,
  BadRequestException,
} from '@nestjs/common';
import { AuditService } from './audit.service';
import { AuditEntity, AuditAction } from '@prisma/client';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

/**
 * Audit API endpoints for querying activity logs and performing forensic investigations.
 * Restricted to authorized users (SUPER_ADMIN for full access, GERENTE for own restaurant).
 */
@Controller('audit')
export class AuditController {
  constructor(private auditService: AuditService) {}

  /**
   * GET /audit/trail
   * Get audit trail for a specific restaurant, entity, or date range.
   *
   * Query params:
   * - restID: Restaurant ID (required for non-SUPER_ADMIN)
   * - entity: AuditEntity enum value (optional)
   * - entityId: Entity ID to filter by (optional)
   * - action: AuditAction enum value (optional)
   * - from: ISO date string (optional)
   * - to: ISO date string (optional)
   * - limit: Number of results (default 100, max 10000)
   * - offset: Pagination offset (default 0)
   */
  @Get('trail')
  async getAuditTrail(
    @Query('restID', new ParseIntPipe({ optional: true })) restID?: number,
    @Query('entity') entity?: string,
    @Query('entityId') entityId?: string,
    @Query('action') action?: string,
    @Query('from') from?: string,
    @Query('to') to?: string,
    @Query('limit', new ParseIntPipe({ optional: true })) limit: number = 100,
    @Query('offset', new ParseIntPipe({ optional: true })) offset: number = 0,
    @CurrentUser() user?: any,
  ) {
    // Validate access
    if (user && user.role !== 'SUPER_ADMIN') {
      if (!restID) {
        throw new BadRequestException('restID is required for non SUPER_ADMIN users');
      }
      assertRestaurantAccess(user, restID);
    }

    if (limit > 10000) limit = 10000;
    if (limit < 1) limit = 1;
    if (offset < 0) offset = 0;

    const query: any = { limit, offset };
    if (restID) query.restID = restID;
    if (entity) query.entity = entity as AuditEntity;
    if (entityId) query.entityId = entityId;
    if (action) query.action = action as AuditAction;
    if (from) query.fromDate = new Date(from);
    if (to) query.toDate = new Date(to);

    return this.auditService.getAuditTrail(query);
  }

  /**
   * GET /audit/user/:userId
   * Get all audit trail entries for a specific user.
   * Accessible only by SUPER_ADMIN or the user themselves.
   */
  @Get('user/:userId')
  async getUserAuditTrail(
    @Param('userId', ParseIntPipe) userId: number,
    @Query('from') from?: string,
    @Query('to') to?: string,
    @Query('limit', new ParseIntPipe({ optional: true })) limit: number = 500,
    @CurrentUser() user?: any,
  ) {
    if (user?.role !== 'SUPER_ADMIN' && user?.id !== userId) {
      throw new BadRequestException('Unauthorized to view this user audit trail');
    }

    if (limit > 10000) limit = 10000;

    return this.auditService.getUserAuditTrail(userId, from ? new Date(from) : undefined, to ? new Date(to) : undefined, limit);
  }

  /**
   * GET /audit/restaurant/:restID
   * Get all audit trail entries for a specific restaurant within a date range.
   * Restricted to SUPER_ADMIN or managers of that restaurant.
   */
  @Get('restaurant/:restID')
  async getRestaurantAuditTrail(
    @Param('restID', ParseIntPipe) restID: number,
    @Query('from') from?: string,
    @Query('to') to?: string,
    @Query('limit', new ParseIntPipe({ optional: true })) limit: number = 1000,
    @CurrentUser() user?: any,
  ) {
    if (user && user.role !== 'SUPER_ADMIN') {
      assertRestaurantAccess(user, restID);
    }

    if (limit > 10000) limit = 10000;

    return this.auditService.getRestaurantAuditTrail(
      restID,
      from ? new Date(from) : undefined,
      to ? new Date(to) : undefined,
      limit,
    );
  }

  /**
   * GET /audit/entity/:entity/:entityId
   * Get detailed change history for a specific entity.
   * Useful for investigating changes to a single transaction, employee, etc.
   */
  @Get('entity/:entity/:entityId')
  async getEntityChangeHistory(
    @Param('entity') entity: string,
    @Param('entityId') entityId: string,
    @Query('restID', new ParseIntPipe({ optional: true })) restID?: number,
    @CurrentUser() user?: any,
  ) {
    if (user && user.role !== 'SUPER_ADMIN') {
      if (!restID) {
        throw new BadRequestException('restID is required for non SUPER_ADMIN users');
      }
      assertRestaurantAccess(user, restID);
    }

    try {
      return await this.auditService.getEntityChangeHistory(
        entity as AuditEntity,
        entityId,
        restID,
      );
    } catch (error) {
      throw new BadRequestException(`Invalid entity type: ${entity}`);
    }
  }

  /**
   * GET /audit/batch/:requestId
   * Get all audit logs for a specific request/batch operation.
   * Useful for understanding what happened during a single API call.
   */
  @Get('batch/:requestId')
  async getBatchAuditLog(
    @Param('requestId') requestId: string,
    @CurrentUser() user?: any,
  ) {
    if (user?.role !== 'SUPER_ADMIN') {
      throw new BadRequestException('Only SUPER_ADMIN can inspect raw batch logs');
    }

    // Validate requestId format (should be UUID)
    if (!requestId.match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i)) {
      throw new BadRequestException('Invalid request ID format');
    }

    return this.auditService.getBatchAuditLog(requestId);
  }

  /**
   * GET /audit/statistics
   * Get summary statistics about audit logging.
   * Restricted to SUPER_ADMIN.
   */
  @Get('statistics')
  async getStatistics(
    @Query('restID', new ParseIntPipe({ optional: true })) restID?: number,
    @CurrentUser() user?: any,
  ) {
    if (user?.role !== 'SUPER_ADMIN') {
      throw new BadRequestException('Only SUPER_ADMIN can view audit statistics');
    }

    return this.auditService.getAuditStatistics(restID);
  }
}
