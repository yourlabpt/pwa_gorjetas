import { AuditAction, AuditEntity } from '@prisma/client';

export interface AuditPayload {
  requestId: string;
  userId: number | null;
  restID: number | null;
  action: AuditAction;
  entity: AuditEntity;
  entityId: string | string[]; // JSON array or comma-separated for bulk ops
  status: 'SUCCESS' | 'FAILED' | 'PENDING';
  valuesBefore?: Record<string, any> | null;
  valuesAfter?: Record<string, any> | null;
  errorMessage?: string;
  ipAddress?: string;
  userAgent?: string;
  duration?: number;
}

export interface AuditTrailQuery {
  restID?: number;
  userId?: number;
  entity?: AuditEntity;
  entityId?: string;
  action?: AuditAction;
  fromDate?: Date;
  toDate?: Date;
  limit?: number;
  offset?: number;
}

export interface AuditTrailResponse {
  total: number;
  limit: number;
  offset: number;
  data: Array<{
    id: number;
    requestId: string;
    userId: number | null;
    restID: number | null;
    action: AuditAction;
    entity: AuditEntity;
    entityId: string;
    status: string;
    valuesBefore: Record<string, any> | null;
    valuesAfter: Record<string, any> | null;
    ipAddress: string | null;
    userAgent: string | null;
    duration: number | null;
    createdAt: Date;
  }>;
}

export interface RollbackBatchResult {
  batchId: string;
  status: 'SUCCESS' | 'FAILED' | 'PARTIAL';
  operationCount: number;
  rollbackBatchId: string;
  errors?: string[];
}

export interface ReplayResult {
  batchId: string;
  restID: number;
  targetTimestamp: Date;
  status: 'SUCCESS' | 'FAILED' | 'PARTIAL';
  operationCount: number;
  errors?: string[];
}
