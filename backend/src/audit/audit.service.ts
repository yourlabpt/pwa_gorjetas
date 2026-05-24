import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { PrismaService } from '../prisma/prisma.service';
import { AuditPayload, AuditTrailQuery, AuditTrailResponse } from './audit.types';
import { AuditAction, AuditEntity, Prisma } from '@prisma/client';
import { randomUUID } from 'crypto';

@Injectable()
export class AuditService {
  private readonly logger = new Logger(AuditService.name);
  private eventQueue: Prisma.AuditLogCreateManyInput[] = [];
  private batchFlushTimer: NodeJS.Timeout | null = null;
  private readonly BATCH_SIZE = 100;
  private readonly FLUSH_INTERVAL_MS = 5000; // 5 seconds

  constructor(
    private prisma: PrismaService,
    private eventEmitter: EventEmitter2,
  ) {
    this.startBatchFlushTimer();
  }

  /**
   * Queue an audit event for asynchronous batched logging.
   * Events are flushed every BATCH_SIZE or FLUSH_INTERVAL_MS, whichever comes first.
   */
  async logAction(payload: Partial<AuditPayload>): Promise<void> {
    const normalized: Prisma.AuditLogCreateManyInput = {
      requestId: payload.requestId || randomUUID(),
      userId: payload.userId ?? null,
      restID: payload.restID ?? null,
      action: payload.action || AuditAction.OTHER,
      entity: payload.entity || AuditEntity.OTHER,
      entityId: Array.isArray(payload.entityId)
        ? payload.entityId.join(',')
        : (payload.entityId || 'unknown').toString(),
      status: payload.status || 'PENDING',
      valuesBefore:
        payload.valuesBefore == null
          ? Prisma.JsonNull
          : (payload.valuesBefore as Prisma.InputJsonValue),
      valuesAfter:
        payload.valuesAfter == null
          ? Prisma.JsonNull
          : (payload.valuesAfter as Prisma.InputJsonValue),
      errorMessage: payload.errorMessage,
      ipAddress: payload.ipAddress,
      userAgent: payload.userAgent,
      duration: payload.duration,
    };

    this.eventQueue.push(normalized);
    if (this.eventQueue.length >= this.BATCH_SIZE) {
      await this.flushBatch(true);
    }
  }

  /**
   * Manually flush queued audit events to the database.
   */
  async flushBatch(force: boolean = false): Promise<void> {
    if (this.eventQueue.length === 0) {
      return;
    }

    const batch = this.eventQueue.splice(0, this.BATCH_SIZE);
    try {
      await this.prisma.auditLog.createMany({
        data: batch,
        skipDuplicates: false,
      });
      this.logger.debug(`Flushed ${batch.length} audit events to database`);
    } catch (error) {
      this.logger.error('Failed to flush audit batch', {
        error,
        batchSize: batch.length,
      });
      // Re-queue failed items
      this.eventQueue.unshift(...batch);
    }
  }

  /**
   * Get audit trail for a specific entity, user, or restaurant.
   * Supports filtering by multiple criteria and date range.
   */
  async getAuditTrail(query: AuditTrailQuery): Promise<AuditTrailResponse> {
    const {
      restID,
      userId,
      entity,
      entityId,
      action,
      fromDate,
      toDate,
      limit = 100,
      offset = 0,
    } = query;

    const where: any = { archived: false };

    if (restID !== undefined) where.restID = restID;
    if (userId !== undefined) where.userId = userId;
    if (entity) where.entity = entity;
    if (entityId) where.entityId = { contains: entityId };
    if (action) where.action = action;
    if (fromDate || toDate) {
      where.createdAt = {};
      if (fromDate) where.createdAt.gte = fromDate;
      if (toDate) where.createdAt.lte = toDate;
    }

    const [data, total] = await Promise.all([
      this.prisma.auditLog.findMany({
        where,
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
        orderBy: { createdAt: 'desc' },
        take: limit,
        skip: offset,
      }),
      this.prisma.auditLog.count({ where }),
    ]);

    return {
      total,
      limit,
      offset,
      data: data.map((log) => ({
        ...log,
        valuesBefore: log.valuesBefore as Record<string, any> | null,
        valuesAfter: log.valuesAfter as Record<string, any> | null,
      })),
    };
  }

  /**
   * Get audit trail for a specific user across all restaurants and dates.
   */
  async getUserAuditTrail(
    userId: number,
    fromDate?: Date,
    toDate?: Date,
    limit: number = 500,
  ): Promise<AuditTrailResponse> {
    return this.getAuditTrail({
      userId,
      fromDate,
      toDate,
      limit,
    });
  }

  /**
   * Get audit trail for a specific restaurant within a date range.
   */
  async getRestaurantAuditTrail(
    restID: number,
    fromDate?: Date,
    toDate?: Date,
    limit: number = 1000,
  ): Promise<AuditTrailResponse> {
    return this.getAuditTrail({
      restID,
      fromDate,
      toDate,
      limit,
    });
  }

  /**
   * Get detailed change history for a specific entity.
   */
  async getEntityChangeHistory(
    entity: AuditEntity,
    entityId: string,
    restID?: number,
  ): Promise<AuditTrailResponse> {
    return this.getAuditTrail({
      entity,
      entityId,
      restID,
      limit: 10000,
    });
  }

  /**
   * Get all actions within a batch (for investigating a specific operation).
   */
  async getBatchAuditLog(requestId: string): Promise<AuditTrailResponse> {
    const where = { requestId, archived: false };
    const [data, total] = await Promise.all([
      this.prisma.auditLog.findMany({
        where,
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
        orderBy: { createdAt: 'desc' },
        take: 10000,
      }),
      this.prisma.auditLog.count({ where }),
    ]);

    return {
      total,
      limit: 10000,
      offset: 0,
      data: data.map((log) => ({
        ...log,
        valuesBefore: log.valuesBefore as Record<string, any> | null,
        valuesAfter: log.valuesAfter as Record<string, any> | null,
      })),
    };
  }

  /**
   * Rollback all changes in a batch operation by replaying audit logs in reverse.
   * Only works for operations with valuesBefore snapshots.
   */
  async rollbackBatchId(batchId: string): Promise<{ status: string; message: string }> {
    try {
      // Fetch all logs in the batch
      const logs = await this.prisma.auditLog.findMany({
        where: {
          requestId: batchId,
          archived: false,
          NOT: { action: 'VIEW' },
        },
        orderBy: { createdAt: 'desc' }, // Reverse order
      });

      if (logs.length === 0) {
        return { status: 'NOT_FOUND', message: 'No audit logs found for this batch' };
      }

      // Create a new batch log entry
      const rollbackBatchId = randomUUID();
      const rollbackBatch = await this.prisma.auditBatchLog.create({
        data: {
          batchId: rollbackBatchId,
          operationType: 'ROLLBACK',
          operationCount: logs.length,
          status: 'PENDING',
          details: {
            originalBatchId: batchId,
            targetedLogs: logs.length,
          },
          rollbackBatchId: batchId,
        },
      });

      // TODO: Implement actual reversal logic per entity type
      // For now, log the intention to audit trail
      await this.prisma.auditBatchLog.update({
        where: { id: rollbackBatch.id },
        data: {
          status: 'PARTIAL', // Mark as partial until reversal is implemented
          details: {
            originalBatchId: batchId,
            targetedLogs: logs.length,
            note: 'Rollback logged but reversal not yet implemented - manual DBA intervention required',
          },
        },
      });

      this.logger.warn(`Rollback batch created: ${rollbackBatchId} for original batch: ${batchId}`);
      return {
        status: 'CREATED',
        message: `Rollback batch ${rollbackBatchId} created. Manual verification required before applying.`,
      };
    } catch (error) {
      this.logger.error('Rollback failed', { batchId, error });
      throw error;
    }
  }

  /**
   * Reconstruct entity state as-of a specific timestamp.
   * Applies all audit logs up to that timestamp.
   */
  async replayToTimestamp(
    restID: number,
    targetTimestamp: Date,
    entity?: AuditEntity,
  ): Promise<{ status: string; message: string; timestamp: Date }> {
    try {
      const replayBatchId = randomUUID();
      const logs = await this.prisma.auditLog.findMany({
        where: {
          restID,
          createdAt: { lte: targetTimestamp },
          archived: false,
          NOT: { action: 'VIEW' },
          ...(entity && { entity }),
        },
        orderBy: { createdAt: 'asc' },
      });

      const batchLog = await this.prisma.auditBatchLog.create({
        data: {
          batchId: replayBatchId,
          operationType: 'REPLAY',
          operationCount: logs.length,
          restID,
          status: 'PENDING',
          details: {
            targetTimestamp: targetTimestamp.toISOString(),
            affectedEntity: entity || 'ALL',
            affectedRecords: logs.length,
          },
        },
      });

      // TODO: Implement actual replay logic
      this.logger.warn(`Replay batch created: ${replayBatchId} for ${restID} to ${targetTimestamp}`);

      return {
        status: 'CREATED',
        message: `Replay batch ${replayBatchId} created with ${logs.length} operations. Manual DBA review required.`,
        timestamp: targetTimestamp,
      };
    } catch (error) {
      this.logger.error('Replay failed', { restID, targetTimestamp, error });
      throw error;
    }
  }

  /**
   * Archive audit logs older than retentionDays.
   * Called automatically by scheduled job.
   */
  async archiveOldLogs(retentionDays: number = 90): Promise<{ archived: number }> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - retentionDays);

    const logsToArchive = await this.prisma.auditLog.findMany({
      where: {
        createdAt: { lt: cutoffDate },
        archived: false,
      },
      select: {
        id: true,
        requestId: true,
        userId: true,
        restID: true,
        action: true,
        entity: true,
        entityId: true,
        status: true,
        valuesBefore: true,
        valuesAfter: true,
        errorMessage: true,
        ipAddress: true,
        userAgent: true,
        duration: true,
        createdAt: true,
      },
    });

    if (logsToArchive.length === 0) {
      this.logger.debug('No audit logs to archive');
      return { archived: 0 };
    }

    try {
      await this.prisma.$transaction([
        // Insert into archive
        this.prisma.auditArchive.createMany({
          data: logsToArchive.map((log) => ({
            requestId: log.requestId,
            userId: log.userId,
            restID: log.restID,
            action: log.action,
            entity: log.entity,
            entityId: log.entityId,
            status: log.status,
            valuesBefore:
              log.valuesBefore == null
                ? Prisma.JsonNull
                : (log.valuesBefore as Prisma.InputJsonValue),
            valuesAfter:
              log.valuesAfter == null
                ? Prisma.JsonNull
                : (log.valuesAfter as Prisma.InputJsonValue),
            errorMessage: log.errorMessage,
            ipAddress: log.ipAddress,
            userAgent: log.userAgent,
            duration: log.duration,
            archivedAt: new Date(),
          })),
        }),
        // Mark as archived in main table
        this.prisma.auditLog.updateMany({
          where: {
            id: { in: logsToArchive.map((l) => l.id) },
          },
          data: {
            archived: true,
            archivedAt: new Date(),
          },
        }),
      ]);

      this.logger.log(`Archived ${logsToArchive.length} audit logs older than ${retentionDays} days`);
      return { archived: logsToArchive.length };
    } catch (error) {
      this.logger.error('Archive failed', { error, count: logsToArchive.length });
      throw error;
    }
  }

  /**
   * Get statistics on audit logging.
   */
  async getAuditStatistics(restID?: number): Promise<{
    total: number;
    byAction: Record<string, number>;
    byEntity: Record<string, number>;
    lastActivity: Date | null;
  }> {
    const where = { archived: false, ...(restID && { restID }) };

    const logs = await this.prisma.auditLog.findMany({
      where,
      select: { action: true, entity: true, createdAt: true },
    });

    const byAction: Record<string, number> = {};
    const byEntity: Record<string, number> = {};
    let lastActivity: Date | null = null;

    logs.forEach((log) => {
      byAction[log.action] = (byAction[log.action] || 0) + 1;
      byEntity[log.entity] = (byEntity[log.entity] || 0) + 1;
      if (!lastActivity || log.createdAt > lastActivity) {
        lastActivity = log.createdAt;
      }
    });

    return {
      total: logs.length,
      byAction,
      byEntity,
      lastActivity,
    };
  }

  /**
   * Start the background timer for periodic batch flushing.
   */
  private startBatchFlushTimer(): void {
    this.batchFlushTimer = setInterval(async () => {
      if (this.eventQueue.length > 0) {
        await this.flushBatch(false);
      }
    }, this.FLUSH_INTERVAL_MS);
  }

  /**
   * Stop the background timer (called on application shutdown).
   */
  async onApplicationShutdown(): Promise<void> {
    if (this.batchFlushTimer) {
      clearInterval(this.batchFlushTimer);
    }
    // Flush any remaining events
    if (this.eventQueue.length > 0) {
      await this.flushBatch(true);
    }
    this.logger.log('Audit service shutdown complete');
  }
}
