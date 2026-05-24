-- CreateEnum
CREATE TYPE "AuditAction" AS ENUM ('CREATED', 'UPDATED', 'DELETED', 'LOGIN', 'LOGOUT', 'VIEW', 'COMPUTE', 'SNAPSHOT', 'SETTLE', 'ROLLBACK', 'REPLAY', 'EXPORTED', 'OTHER');

-- CreateEnum
CREATE TYPE "AuditEntity" AS ENUM ('User', 'Restaurante', 'Funcionario', 'FuncionarioRestaurante', 'Transacao', 'DistribuicaoGorjetas', 'FaturamentoDiario', 'FaturamentoDiarioDistribuicao', 'ConfiguracaoAcerto', 'AcertoPeriodo', 'AcertoFuncionario', 'AcertoFinalPeriodo', 'AcertoFinalEntry', 'FechoFinanceiro', 'FechoFinanceiroTemplate', 'FechoFinanceiroItem', 'RegraDistribuicao', 'FuncionarioPresencaDiaria', 'OTHER');

-- CreateTable
CREATE TABLE "audit_log" (
    "id" SERIAL NOT NULL,
    "requestId" VARCHAR(36) NOT NULL,
    "userId" INTEGER,
    "restID" INTEGER,
    "action" "AuditAction" NOT NULL,
    "entity" "AuditEntity" NOT NULL,
    "entityId" VARCHAR(255) NOT NULL,
    "status" VARCHAR(20) NOT NULL,
    "valuesBefore" JSONB,
    "valuesAfter" JSONB,
    "errorMessage" TEXT,
    "ipAddress" VARCHAR(45),
    "userAgent" VARCHAR(500),
    "duration" INTEGER,
    "archived" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "archivedAt" TIMESTAMP(3),

    CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_archive" (
    "id" SERIAL NOT NULL,
    "requestId" VARCHAR(36) NOT NULL,
    "userId" INTEGER,
    "restID" INTEGER,
    "action" "AuditAction" NOT NULL,
    "entity" "AuditEntity" NOT NULL,
    "entityId" VARCHAR(255) NOT NULL,
    "status" VARCHAR(20) NOT NULL,
    "valuesBefore" JSONB,
    "valuesAfter" JSONB,
    "errorMessage" TEXT,
    "ipAddress" VARCHAR(45),
    "userAgent" VARCHAR(500),
    "duration" INTEGER,
    "archivedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_archive_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_batch_log" (
    "id" SERIAL NOT NULL,
    "batchId" VARCHAR(36) NOT NULL,
    "userId" INTEGER,
    "restID" INTEGER,
    "operationType" VARCHAR(50) NOT NULL,
    "operationCount" INTEGER NOT NULL DEFAULT 0,
    "status" VARCHAR(20) NOT NULL,
    "details" JSONB,
    "rollbackBatchId" VARCHAR(36),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "audit_batch_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "audit_log_restID_createdAt_idx" ON "audit_log"("restID" DESC, "createdAt" DESC);

-- CreateIndex
CREATE INDEX "audit_log_userId_createdAt_idx" ON "audit_log"("userId" DESC, "createdAt" DESC);

-- CreateIndex
CREATE INDEX "audit_log_entity_entityId_idx" ON "audit_log"("entity", "entityId");

-- CreateIndex
CREATE INDEX "audit_log_requestId_idx" ON "audit_log"("requestId");

-- CreateIndex
CREATE INDEX "audit_log_action_idx" ON "audit_log"("action");

-- CreateIndex
CREATE INDEX "audit_log_archived_idx" ON "audit_log"("archived");

-- CreateIndex
CREATE UNIQUE INDEX "audit_batch_log_batchId_key" ON "audit_batch_log"("batchId");

-- CreateIndex
CREATE INDEX "audit_batch_log_restID_idx" ON "audit_batch_log"("restID");

-- CreateIndex
CREATE INDEX "audit_batch_log_userId_idx" ON "audit_batch_log"("userId");

-- CreateIndex
CREATE INDEX "audit_batch_log_createdAt_idx" ON "audit_batch_log"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "audit_archive_restID_archivedAt_idx" ON "audit_archive"("restID" DESC, "archivedAt" DESC);

-- CreateIndex
CREATE INDEX "audit_archive_entity_entityId_idx" ON "audit_archive"("entity", "entityId");
