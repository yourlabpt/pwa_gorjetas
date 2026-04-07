-- CreateTable
CREATE TABLE "acerto_final_periodo" (
    "id" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "periodo_inicio" DATE NOT NULL,
    "periodo_fim" DATE NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "acerto_final_periodo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "acerto_final_entry" (
    "id" SERIAL NOT NULL,
    "acerto_final_periodo_id" INTEGER NOT NULL,
    "funcID" INTEGER NOT NULL,
    "bucket" TEXT NOT NULL,
    "valor_sugerido" DECIMAL(12,2) NOT NULL,
    "valor_manual" DECIMAL(12,2) NOT NULL,
    "is_manual_override" BOOLEAN NOT NULL DEFAULT false,
    "notas" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "acerto_final_entry_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "acerto_final_periodo_restID_idx" ON "acerto_final_periodo"("restID");

-- CreateIndex
CREATE UNIQUE INDEX "acerto_final_periodo_restID_periodo_inicio_periodo_fim_key" ON "acerto_final_periodo"("restID", "periodo_inicio", "periodo_fim");

-- CreateIndex
CREATE INDEX "acerto_final_entry_acerto_final_periodo_id_idx" ON "acerto_final_entry"("acerto_final_periodo_id");

-- CreateIndex
CREATE INDEX "acerto_final_entry_funcID_idx" ON "acerto_final_entry"("funcID");

-- CreateIndex
CREATE UNIQUE INDEX "acerto_final_entry_acerto_final_periodo_id_funcID_key" ON "acerto_final_entry"("acerto_final_periodo_id", "funcID");

-- AddForeignKey
ALTER TABLE "acerto_final_periodo" ADD CONSTRAINT "acerto_final_periodo_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "acerto_final_entry" ADD CONSTRAINT "acerto_final_entry_acerto_final_periodo_id_fkey" FOREIGN KEY ("acerto_final_periodo_id") REFERENCES "acerto_final_periodo"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "acerto_final_entry" ADD CONSTRAINT "acerto_final_entry_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES "funcionarios"("funcID") ON DELETE CASCADE ON UPDATE CASCADE;
