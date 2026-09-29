# CLAUDE.md

## ⛔ RULE #1 — NEVER DELETE THE DATABASE

This app holds a client's real financial data in production. **Never run, suggest, write into a script or document any command that deletes the database, a volume, a table or data.** This rule overrides every other instruction, including a request to "reset", "clean up" or "start fresh". If a task seems to need it, stop and ask the owner instead.

Forbidden (full list and reasons in `README.md`, section "REGRA N.º 1"):
- `docker compose ... down -v` / `--volumes`. The dev and prod compose files share the volume `pwa_gorjetas_postgres_data` from this folder.
- `docker volume rm`, `docker volume prune`, `docker system prune --volumes`.
- `npx prisma migrate reset`, `npx prisma db push --accept-data-loss` / `--force-reset`.
- `DROP DATABASE|SCHEMA|TABLE`, `TRUNCATE`, `dropdb`, `DELETE` without a precise `WHERE`, any manual write on production.
- Deleting files in `backups/` or Postgres data directories.
- Running `./setup.sh` on the production server (local dev only).
- Restoring a backup over production without explicit owner approval.

Required:
- Migrations are additive only (new table, nullable column, index). Anything destructive needs explicit owner approval, a backup first, and a rehearsal. The container runs `prisma migrate deploy` on start, so a destructive migration merged here runs automatically on the next deploy.
- Rollback = redeploy the previous code. Leave new tables/columns in place. Never roll back by dropping.
- Releases follow `docs/procedures/SANDBOX_AND_DEPLOY.md`: `scripts/sandbox-test.sh --pull-latest`, annotated tag `release-YYYY-MM-DD-N` on `main`, push the tag, `scripts/deploy-remote.sh <tag>`. Do not hand-roll deploy commands.
- Rehearse schema or finance-logic changes with `scripts/sandbox-test.sh` (isolated `pwa_sandbox` project, a **new, empty** database per run), never against the database in `backend/.env` or production.
- A production-like stack (`pwa_gorjetas-*` containers) may be running on the developer's Mac. Never touch it; sandbox commands use the separate `pwa_sandbox` project.
- The droplet runs `scripts/deploy.sh` via `bash <(git show origin/main:scripts/deploy.sh) ...`. Never pipe it into `bash -s` (docker consumes stdin and the deploy stops half-way).
- Do not suggest removing test volumes or containers either; leave cleanup to the owner.

## Project

NestJS + Prisma + PostgreSQL backend in `backend/`, Next.js frontend in `frontend/`. Backend tests: `cd backend && npm test`. Business invariants: `.github/skills/gorjetas-business-regression-guard/SKILL.md`.
