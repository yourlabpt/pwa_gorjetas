-- CreateTable
CREATE TABLE "fecho_financeiro_template" (
    "id" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "label" TEXT NOT NULL,
    "ordem" INTEGER NOT NULL DEFAULT 0,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fecho_financeiro_template_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fecho_financeiro" (
    "id" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "data" DATE NOT NULL,
    "faturamento_global" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "dinheiro_a_depositar" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "notas" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fecho_financeiro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fecho_financeiro_item" (
    "id" SERIAL NOT NULL,
    "fecID" INTEGER NOT NULL,
    "templateId" INTEGER,
    "label" TEXT NOT NULL,
    "valor" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fecho_financeiro_item_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "fecho_financeiro_template_restID_idx" ON "fecho_financeiro_template"("restID");

-- CreateIndex
CREATE UNIQUE INDEX "fecho_financeiro_restID_data_key" ON "fecho_financeiro"("restID", "data");

-- CreateIndex
CREATE INDEX "fecho_financeiro_restID_idx" ON "fecho_financeiro"("restID");

-- CreateIndex
CREATE INDEX "fecho_financeiro_data_idx" ON "fecho_financeiro"("data");

-- CreateIndex
CREATE INDEX "fecho_financeiro_item_fecID_idx" ON "fecho_financeiro_item"("fecID");

-- AddForeignKey
ALTER TABLE "fecho_financeiro_template" ADD CONSTRAINT "fecho_financeiro_template_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fecho_financeiro" ADD CONSTRAINT "fecho_financeiro_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fecho_financeiro_item" ADD CONSTRAINT "fecho_financeiro_item_fecID_fkey" FOREIGN KEY ("fecID") REFERENCES "fecho_financeiro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fecho_financeiro_item" ADD CONSTRAINT "fecho_financeiro_item_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "fecho_financeiro_template"("id") ON DELETE SET NULL ON UPDATE CASCADE;
