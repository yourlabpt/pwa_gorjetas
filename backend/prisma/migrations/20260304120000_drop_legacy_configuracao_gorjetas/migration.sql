-- Legacy table no longer used by runtime finance calculation.
-- Canonical rule source is now regras_distribuicao.
--
-- Safety backfill: copy legacy role configs into canonical rules when a
-- canonical role rule does not already exist for that restaurant.
INSERT INTO "regras_distribuicao" (
  "restID",
  "role_name",
  "calculation_type",
  "calculation_base",
  "rate",
  "payment_source",
  "ordem",
  "ativo",
  "criadoEm",
  "atualizadoEm"
)
SELECT
  cg."restID",
  LOWER(TRIM(cg."funcao")) AS "role_name",
  'PERCENT'::"CalculationType" AS "calculation_type",
  'VALOR_TOTAL_GORJETAS'::"CalculationBase" AS "calculation_base",
  cg."percentagem"::DECIMAL(12,4) AS "rate",
  'TIP_POOL'::"PaymentSource" AS "payment_source",
  COALESCE(cg."ordem_calculo", 0) AS "ordem",
  cg."ativo",
  cg."createdAt" AS "criadoEm",
  cg."updatedAt" AS "atualizadoEm"
FROM "configuracao_gorjetas" cg
WHERE NOT EXISTS (
  SELECT 1
  FROM "regras_distribuicao" rd
  WHERE rd."restID" = cg."restID"
    AND LOWER(TRIM(rd."role_name")) = LOWER(TRIM(cg."funcao"))
);

DROP TABLE IF EXISTS "configuracao_gorjetas";
