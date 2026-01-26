-- CreateTable
CREATE TABLE "faturamento_diario_distribuicao" (
    "id" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "data" DATE NOT NULL,
    "funcID" INTEGER,
    "role" TEXT NOT NULL,
    "valor_pool" DECIMAL(12,2),
    "valor_direto" DECIMAL(12,2),
    "valor_teorico" DECIMAL(12,2),
    "valor_pago" DECIMAL(12,2) NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "faturamento_diario_distribuicao_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "faturamento_diario_distribuicao_restID_idx" ON "faturamento_diario_distribuicao"("restID");

-- CreateIndex
CREATE INDEX "faturamento_diario_distribuicao_data_idx" ON "faturamento_diario_distribuicao"("data");

-- CreateIndex
CREATE UNIQUE INDEX "faturamento_diario_distribuicao_restID_data_funcID_role_key" ON "faturamento_diario_distribuicao"("restID", "data", "funcID", "role");

-- AddForeignKey
ALTER TABLE "faturamento_diario_distribuicao" ADD CONSTRAINT "faturamento_diario_distribuicao_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faturamento_diario_distribuicao" ADD CONSTRAINT "faturamento_diario_distribuicao_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES "funcionarios"("funcID") ON DELETE SET NULL ON UPDATE CASCADE;
