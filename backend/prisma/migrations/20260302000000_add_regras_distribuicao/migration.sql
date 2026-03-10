-- CreateEnum
CREATE TYPE "CalculationType" AS ENUM ('PERCENT', 'FIXED_AMOUNT');

-- CreateEnum
CREATE TYPE "CalculationBase" AS ENUM ('FATURAMENTO_GLOBAL', 'FATURAMENTO_COM_GORJETA', 'FATURAMENTO_SEM_GORJETA', 'VALOR_TOTAL_GORJETAS');

-- CreateEnum
CREATE TYPE "PaymentSource" AS ENUM ('TIP_POOL', 'FINANCEIRO', 'ABSOLUTE_EXTERNAL');

-- AlterTable: add new bucket columns to faturamento_diario (nullable for backward compat)
ALTER TABLE "faturamento_diario"
  ADD COLUMN "faturamento_com_gorjeta" DECIMAL(12,2),
  ADD COLUMN "faturamento_sem_gorjeta" DECIMAL(12,2),
  ADD COLUMN "valor_total_gorjetas"    DECIMAL(12,2);

-- CreateTable
CREATE TABLE "regras_distribuicao" (
    "id"               SERIAL NOT NULL,
    "restID"           INTEGER NOT NULL,
    "role_name"        TEXT NOT NULL,
    "calculation_type" "CalculationType" NOT NULL,
    "calculation_base" "CalculationBase",
    "rate"             DECIMAL(12,4) NOT NULL,
    "payment_source"   "PaymentSource" NOT NULL,
    "ordem"            INTEGER NOT NULL DEFAULT 0,
    "ativo"            BOOLEAN NOT NULL DEFAULT true,
    "criadoEm"         TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm"     TIMESTAMP(3) NOT NULL,

    CONSTRAINT "regras_distribuicao_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "regras_distribuicao_restID_idx"       ON "regras_distribuicao"("restID");
CREATE INDEX "regras_distribuicao_restID_ativo_idx"  ON "regras_distribuicao"("restID", "ativo");

-- AddForeignKey
ALTER TABLE "regras_distribuicao"
  ADD CONSTRAINT "regras_distribuicao_restID_fkey"
  FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;
