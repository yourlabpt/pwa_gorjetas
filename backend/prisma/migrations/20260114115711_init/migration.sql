-- CreateTable
CREATE TABLE "restaurantes" (
    "restID" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "endereco" TEXT,
    "contacto" TEXT,
    "percentagem_gorjeta_base" DECIMAL(5,2) NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "restaurantes_pkey" PRIMARY KEY ("restID")
);

-- CreateTable
CREATE TABLE "funcionarios" (
    "funcID" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "contacto" TEXT,
    "photo" TEXT,
    "funcao" TEXT NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "restID" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "funcionarios_pkey" PRIMARY KEY ("funcID")
);

-- CreateTable
CREATE TABLE "configuracao_gorjetas" (
    "configID" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "funcao" TEXT NOT NULL,
    "percentagem" DECIMAL(5,2) NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "configuracao_gorjetas_pkey" PRIMARY KEY ("configID")
);

-- CreateTable
CREATE TABLE "transacoes" (
    "tranID" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "total" DECIMAL(10,2) NOT NULL,
    "valor_gorjeta_calculada" DECIMAL(10,2) NOT NULL,
    "percentagem_aplicada" DECIMAL(5,2) NOT NULL,
    "mbway" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "funcID_garcom" INTEGER NOT NULL,
    "restID" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "transacoes_pkey" PRIMARY KEY ("tranID")
);

-- CreateTable
CREATE TABLE "distribuicao_gorjetas" (
    "distID" SERIAL NOT NULL,
    "tranID" INTEGER NOT NULL,
    "funcID" INTEGER NOT NULL,
    "tipo_distribuicao" TEXT NOT NULL,
    "percentagem_aplicada" DECIMAL(5,2) NOT NULL,
    "valor_calculado" DECIMAL(10,2) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "distribuicao_gorjetas_pkey" PRIMARY KEY ("distID")
);

-- CreateTable
CREATE TABLE "limpeza" (
    "prodID" SERIAL NOT NULL,
    "restID" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "quantidade" DECIMAL(10,2) NOT NULL,
    "unidade" TEXT NOT NULL,
    "preco_unitario" DECIMAL(10,2) NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "limpeza_pkey" PRIMARY KEY ("prodID")
);

-- CreateTable
CREATE TABLE "limpeza_records" (
    "recordID" SERIAL NOT NULL,
    "prodID" INTEGER NOT NULL,
    "funcID" INTEGER NOT NULL,
    "quantidade_usada" DECIMAL(10,2) NOT NULL,
    "data" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "limpeza_records_pkey" PRIMARY KEY ("recordID")
);

-- CreateIndex
CREATE INDEX "funcionarios_restID_idx" ON "funcionarios"("restID");

-- CreateIndex
CREATE UNIQUE INDEX "funcionarios_restID_funcao_key" ON "funcionarios"("restID", "funcao");

-- CreateIndex
CREATE INDEX "configuracao_gorjetas_restID_idx" ON "configuracao_gorjetas"("restID");

-- CreateIndex
CREATE UNIQUE INDEX "configuracao_gorjetas_restID_funcao_key" ON "configuracao_gorjetas"("restID", "funcao");

-- CreateIndex
CREATE INDEX "transacoes_restID_idx" ON "transacoes"("restID");

-- CreateIndex
CREATE INDEX "transacoes_funcID_garcom_idx" ON "transacoes"("funcID_garcom");

-- CreateIndex
CREATE INDEX "transacoes_createdAt_idx" ON "transacoes"("createdAt");

-- CreateIndex
CREATE INDEX "distribuicao_gorjetas_tranID_idx" ON "distribuicao_gorjetas"("tranID");

-- CreateIndex
CREATE INDEX "distribuicao_gorjetas_funcID_idx" ON "distribuicao_gorjetas"("funcID");

-- CreateIndex
CREATE INDEX "limpeza_restID_idx" ON "limpeza"("restID");

-- CreateIndex
CREATE INDEX "limpeza_records_prodID_idx" ON "limpeza_records"("prodID");

-- CreateIndex
CREATE INDEX "limpeza_records_funcID_idx" ON "limpeza_records"("funcID");

-- AddForeignKey
ALTER TABLE "funcionarios" ADD CONSTRAINT "funcionarios_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "configuracao_gorjetas" ADD CONSTRAINT "configuracao_gorjetas_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transacoes" ADD CONSTRAINT "transacoes_funcID_garcom_fkey" FOREIGN KEY ("funcID_garcom") REFERENCES "funcionarios"("funcID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transacoes" ADD CONSTRAINT "transacoes_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distribuicao_gorjetas" ADD CONSTRAINT "distribuicao_gorjetas_tranID_fkey" FOREIGN KEY ("tranID") REFERENCES "transacoes"("tranID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distribuicao_gorjetas" ADD CONSTRAINT "distribuicao_gorjetas_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES "funcionarios"("funcID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "limpeza" ADD CONSTRAINT "limpeza_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "limpeza_records" ADD CONSTRAINT "limpeza_records_prodID_fkey" FOREIGN KEY ("prodID") REFERENCES "limpeza"("prodID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "limpeza_records" ADD CONSTRAINT "limpeza_records_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES "funcionarios"("funcID") ON DELETE RESTRICT ON UPDATE CASCADE;
