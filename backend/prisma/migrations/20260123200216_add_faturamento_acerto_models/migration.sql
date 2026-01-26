-- AlterTable
ALTER TABLE "transacoes" ADD COLUMN     "acerto_periodo_id" INTEGER,
ADD COLUMN     "pago" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "faturamento_diario" (
    "id" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "data" DATE NOT NULL,
    "faturamento_inserido" DECIMAL(12,2) NOT NULL,
    "faturamento_calculado" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "diferenca_percentual" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "notas" TEXT,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "faturamento_diario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "configuracao_acerto" (
    "id" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "funcao" TEXT NOT NULL,
    "base_calculo" TEXT NOT NULL,
    "valor_percentual" DECIMAL(5,2),
    "valor_absoluto" DECIMAL(10,2),
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "configuracao_acerto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "acerto_periodo" (
    "id" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "periodo_inicio" DATE NOT NULL,
    "periodo_fim" DATE NOT NULL,
    "tipo_periodo" TEXT NOT NULL,
    "faturamento_total" DECIMAL(12,2) NOT NULL,
    "gorjeta_total" DECIMAL(12,2) NOT NULL,
    "pago" BOOLEAN NOT NULL DEFAULT false,
    "data_pagamento" TIMESTAMP(3),
    "usuario_pagamento_id" INTEGER,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "acerto_periodo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "acerto_funcionario" (
    "id" SERIAL NOT NULL,
    "acerto_periodo_id" INTEGER NOT NULL,
    "funcID" INTEGER NOT NULL,
    "configuracao_acerto_id" INTEGER NOT NULL,
    "funcao" TEXT NOT NULL,
    "valor_base" DECIMAL(12,2) NOT NULL,
    "percentual_aplicado" DECIMAL(5,2),
    "valor_absoluto_aplicado" DECIMAL(10,2),
    "valor_calculado" DECIMAL(12,2) NOT NULL,
    "pago" BOOLEAN NOT NULL DEFAULT false,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "acerto_funcionario_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "faturamento_diario_restID_idx" ON "faturamento_diario"("restID");

-- CreateIndex
CREATE INDEX "faturamento_diario_data_idx" ON "faturamento_diario"("data");

-- CreateIndex
CREATE UNIQUE INDEX "faturamento_diario_restID_data_key" ON "faturamento_diario"("restID", "data");

-- CreateIndex
CREATE INDEX "configuracao_acerto_restID_idx" ON "configuracao_acerto"("restID");

-- CreateIndex
CREATE UNIQUE INDEX "configuracao_acerto_restID_funcao_key" ON "configuracao_acerto"("restID", "funcao");

-- CreateIndex
CREATE INDEX "acerto_periodo_restID_idx" ON "acerto_periodo"("restID");

-- CreateIndex
CREATE INDEX "acerto_periodo_pago_idx" ON "acerto_periodo"("pago");

-- CreateIndex
CREATE INDEX "acerto_periodo_periodo_inicio_idx" ON "acerto_periodo"("periodo_inicio");

-- CreateIndex
CREATE INDEX "acerto_funcionario_acerto_periodo_id_idx" ON "acerto_funcionario"("acerto_periodo_id");

-- CreateIndex
CREATE INDEX "acerto_funcionario_funcID_idx" ON "acerto_funcionario"("funcID");

-- CreateIndex
CREATE INDEX "transacoes_pago_idx" ON "transacoes"("pago");

-- AddForeignKey
ALTER TABLE "transacoes" ADD CONSTRAINT "transacoes_acerto_periodo_id_fkey" FOREIGN KEY ("acerto_periodo_id") REFERENCES "acerto_periodo"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faturamento_diario" ADD CONSTRAINT "faturamento_diario_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "configuracao_acerto" ADD CONSTRAINT "configuracao_acerto_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "acerto_periodo" ADD CONSTRAINT "acerto_periodo_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "acerto_funcionario" ADD CONSTRAINT "acerto_funcionario_acerto_periodo_id_fkey" FOREIGN KEY ("acerto_periodo_id") REFERENCES "acerto_periodo"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "acerto_funcionario" ADD CONSTRAINT "acerto_funcionario_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES "funcionarios"("funcID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "acerto_funcionario" ADD CONSTRAINT "acerto_funcionario_configuracao_acerto_id_fkey" FOREIGN KEY ("configuracao_acerto_id") REFERENCES "configuracao_acerto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
