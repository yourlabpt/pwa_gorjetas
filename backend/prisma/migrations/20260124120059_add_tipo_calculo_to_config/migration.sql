-- AlterTable
ALTER TABLE "configuracao_gorjetas" ADD COLUMN     "ordem_calculo" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "tipo_calculo" TEXT NOT NULL DEFAULT 'percentagem';

-- CreateIndex
CREATE INDEX "configuracao_gorjetas_ordem_calculo_idx" ON "configuracao_gorjetas"("ordem_calculo");
