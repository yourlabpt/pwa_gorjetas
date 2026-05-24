import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { AuditService } from './audit.service';
import { AuditPayload } from './audit.types';

/**
 * Listens for audit events emitted throughout the application
 * and delegates to the AuditService for batched, asynchronous logging.
 */
@Injectable()
export class AuditEventListener {
  private readonly logger = new Logger(AuditEventListener.name);

  constructor(private auditService: AuditService) {}

  /**
   * Listen for 'audit.action' events emitted by services.
   * This allows logging to be non-blocking and batched for performance.
   */
  @OnEvent('audit.action')
  async handleAuditEvent(payload: AuditPayload): Promise<void> {
    try {
      await this.auditService.logAction(payload);
    } catch (error) {
      this.logger.error('Failed to log audit event', { payload, error });
    }
  }

  /**
   * Listen for batch flush requests (manual or scheduled).
   */
  @OnEvent('audit.flush')
  async handleFlushRequest(force?: boolean): Promise<void> {
    try {
      await this.auditService.flushBatch(force);
    } catch (error) {
      this.logger.error('Failed to flush audit batch', { error });
    }
  }

  /**
   * Listen for archive requests (from scheduled jobs).
   */
  @OnEvent('audit.archive')
  async handleArchiveRequest(retentionDays: number = 90): Promise<void> {
    try {
      const result = await this.auditService.archiveOldLogs(retentionDays);
      this.logger.log(`Archived audit logs: ${result.archived} records`);
    } catch (error) {
      this.logger.error('Failed to archive audit logs', { error });
    }
  }
}
