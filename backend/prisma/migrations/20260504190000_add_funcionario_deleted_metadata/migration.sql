-- AlterTable
ALTER TABLE "funcionarios"
ADD COLUMN "deletedAt" TIMESTAMP(3),
ADD COLUMN "deleteReason" TEXT;

-- CreateIndex
CREATE INDEX "funcionarios_restID_deletedAt_idx" ON "funcionarios"("restID", "deletedAt");