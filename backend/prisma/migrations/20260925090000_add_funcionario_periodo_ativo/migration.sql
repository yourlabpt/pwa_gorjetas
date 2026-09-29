-- Activity periods for employees. Additive only: creates one new table and
-- backfills it from existing data. No existing table is altered or updated.

CREATE TABLE IF NOT EXISTS "funcionario_periodo_ativo" (
    "id"     SERIAL NOT NULL,
    "funcID" INTEGER NOT NULL,
    "inicio" DATE NOT NULL,
    "fim"    DATE,

    CONSTRAINT "funcionario_periodo_ativo_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "funcionario_periodo_ativo_funcID_fkey" FOREIGN KEY ("funcID")
        REFERENCES "funcionarios"("funcID") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "funcionario_periodo_ativo_fim_check" CHECK ("fim" IS NULL OR "fim" >= "inicio")
);

CREATE INDEX IF NOT EXISTS "funcionario_periodo_ativo_funcID_idx"
    ON "funcionario_periodo_ativo"("funcID");

-- Backfill: one period per employee.
--   inicio = earliest of createdAt, data_admissao, first stored financial/presence day
--   fim    = NULL while active; otherwise last stored day (else deletedAt/updatedAt), never before inicio
INSERT INTO "funcionario_periodo_ativo" ("funcID", "inicio", "fim")
SELECT
    b."funcID",
    b."inicio",
    CASE WHEN b."ativo" THEN NULL ELSE GREATEST(b."fim_raw", b."inicio") END
FROM (
    SELECT
        f."funcID",
        f."ativo",
        LEAST(
            f."createdAt"::date,
            COALESCE(f."data_admissao", f."createdAt"::date),
            d."mn",
            p."mn"
        ) AS "inicio",
        COALESCE(
            GREATEST(d."mx", p."mx"),
            COALESCE(f."deletedAt", f."updatedAt")::date
        ) AS "fim_raw"
    FROM "funcionarios" f
    LEFT JOIN (
        SELECT "funcID", MIN("data") AS "mn", MAX("data") AS "mx"
        FROM "faturamento_diario_distribuicao"
        WHERE "funcID" IS NOT NULL
        GROUP BY "funcID"
    ) d ON d."funcID" = f."funcID"
    LEFT JOIN (
        SELECT "funcID", MIN("data") AS "mn", MAX("data") AS "mx"
        FROM "funcionario_presenca_diaria"
        GROUP BY "funcID"
    ) p ON p."funcID" = f."funcID"
) b
WHERE NOT EXISTS (SELECT 1 FROM "funcionario_periodo_ativo");
