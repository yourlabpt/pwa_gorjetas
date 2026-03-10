CREATE TYPE "SettlementType" AS ENUM ('DIARIO', 'PERIODO');

ALTER TABLE "regras_distribuicao"
  ADD COLUMN "tipo_de_acerto" "SettlementType" NOT NULL DEFAULT 'DIARIO';

-- Backward compatibility: existing rules remain daily-settled unless explicitly changed.
UPDATE "regras_distribuicao"
SET "tipo_de_acerto" = 'DIARIO'
WHERE "tipo_de_acerto" IS NULL;
