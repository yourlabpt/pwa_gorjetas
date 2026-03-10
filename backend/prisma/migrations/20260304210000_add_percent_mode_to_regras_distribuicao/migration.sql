-- Add percentage interpretation mode for PERCENT rules.
CREATE TYPE "PercentMode" AS ENUM ('ABSOLUTE_PERCENT', 'BASE_PERCENT_POINTS');

ALTER TABLE "regras_distribuicao"
  ADD COLUMN "percent_mode" "PercentMode" NOT NULL DEFAULT 'ABSOLUTE_PERCENT';

-- Legacy-compatible behavior: tip-pool percentage rules on total tips
-- are interpreted as points of restaurant base percentage.
UPDATE "regras_distribuicao"
SET "percent_mode" = 'BASE_PERCENT_POINTS'
WHERE "calculation_type" = 'PERCENT'::"CalculationType"
  AND "calculation_base" = 'VALOR_TOTAL_GORJETAS'::"CalculationBase"
  AND "payment_source" = 'TIP_POOL'::"PaymentSource";
