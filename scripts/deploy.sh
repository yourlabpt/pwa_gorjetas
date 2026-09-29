#!/usr/bin/env bash
# Production deploy. Runs ON THE DROPLET inside the git clone.
# Normally launched from a laptop by scripts/deploy-remote.sh, which always runs
# the newest copy of this script from origin/main:
#   bash <(git show origin/main:scripts/deploy.sh) [--check] <release-tag>
# Do NOT pipe it into `bash -s`: docker commands would read the rest of the
# script from stdin and the deploy would stop half-way.
#
# Never deletes data, volumes, tables or backups (README "REGRA N.º 1").
# Order: checks -> protect files git would remove -> verified backup -> checkout
#        -> build & start -> health + migrations + row counts -> auto code rollback on failure.
set -euo pipefail

if [ "$0" = "bash" ] || [ "$0" = "-bash" ]; then
  echo "⛔ Run as: bash <(git show origin/main:scripts/deploy.sh) [--check] <release-tag>  (not via a pipe)"
  exit 1
fi
exec < /dev/null   # no child command may read stdin

CHECK_ONLY=0
if [ "${1:-}" = "--check" ]; then CHECK_ONLY=1; shift; fi
REF="${1:?usage: deploy.sh [--check] <release-tag>}"

die() { echo; echo "⛔ DEPLOY STOPPED: $*"; exit 1; }
step() { echo; echo "▶ $*"; }

git rev-parse --git-dir >/dev/null 2>&1 && [ -f docker-compose.prod.yml ] || die "run from the git clone of pwa_gorjetas"
[ -f deploy/server.env ] || die "deploy/server.env missing (copy deploy/server.env.example and fill it in)"
# shellcheck disable=SC1091
. deploy/server.env
: "${COMPOSE_ARGS:?set COMPOSE_ARGS in deploy/server.env}"
: "${DB_CONTAINER:?set DB_CONTAINER in deploy/server.env}"
: "${SAFE_BACKUP_DIR:?set SAFE_BACKUP_DIR in deploy/server.env}"
ENV_FILE="${ENV_FILE:-.env.production}"
DOCKER="${DOCKER:-docker}"
MIN_FREE_GB="${MIN_FREE_GB:-3}"
export APPROVED_MIGRATIONS="${APPROVED_MIGRATIONS:-}"

# shellcheck disable=SC2086
DC() { $DOCKER compose $COMPOSE_ARGS "$@"; }
# shellcheck disable=SC2086
DK() { $DOCKER "$@"; }

TS="$(date +%Y%m%d_%H%M%S)"
mkdir -p "$SAFE_BACKUP_DIR"
SAFE_ABS="$(cd "$SAFE_BACKUP_DIR" && pwd)"
REPO_ABS="$(pwd)"
case "$SAFE_ABS/" in "$REPO_ABS/"*) die "SAFE_BACKUP_DIR must be outside the git clone ($REPO_ABS)";; esac
LOG="$SAFE_ABS/deploy_$TS.log"
exec > >(tee -a "$LOG") 2>&1

LOCK=/tmp/pwa_gorjetas_deploy.lock
mkdir "$LOCK" 2>/dev/null || die "another deploy is running (lock $LOCK)"
trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT

DB_USER="${DB_USER:-$(grep -E '^POSTGRES_USER=' "$ENV_FILE" 2>/dev/null | cut -d= -f2- || true)}"; DB_USER="${DB_USER:-app}"
DB_NAME="${DB_NAME:-$(grep -E '^POSTGRES_DB=' "$ENV_FILE" 2>/dev/null | cut -d= -f2- || true)}"; DB_NAME="${DB_NAME:-app}"
psql_db() { DK exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -tA "$@"; }
COUNTS_SQL="SELECT table_name || '|' || (xpath('/row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM public.%I', table_name), false, true, '')))[1]::text
FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1"

record() { echo "$TS | $(git rev-parse --short "$CURRENT") -> $REF | $1" >> "$SAFE_ABS/deploy-history.log"; }

# ---------------------------------------------------------------- 1. checks
step "1/7 Pre-flight checks (nothing is changed in this step)"
if ! git diff --quiet HEAD; then
  git status --short --untracked-files=no
  die "tracked files were edited on the server. Commit them to the repo instead of editing here."
fi
TARGET="$(git rev-parse --verify --quiet "refs/tags/$REF^{commit}")" || die "tag $REF not found. Tag and push it first (git push origin $REF)"
git merge-base --is-ancestor "$TARGET" origin/main || die "tag $REF is not on origin/main (merge it first)"
CURRENT="$(git rev-parse HEAD)"
CURRENT_NAME="$(git describe --tags --exact-match "$CURRENT" 2>/dev/null || git rev-parse --short "$CURRENT")"
echo "Current: $CURRENT_NAME   Target: $REF ($(git rev-parse --short "$TARGET"))"

[ "$(DK inspect -f '{{.State.Running}}' "$DB_CONTAINER" 2>/dev/null)" = "true" ] || die "database container $DB_CONTAINER is not running"
RUNNING_ID="$(DK inspect -f '{{.Id}}' "$DB_CONTAINER")"
[ "$(DC ps -q db 2>/dev/null)" = "$RUNNING_ID" ] || die "COMPOSE_ARGS does not manage $DB_CONTAINER. Fix deploy/server.env; deploying with the wrong compose files could start a second stack."
psql_db -c "SELECT 1" >/dev/null || die "cannot query $DB_NAME as $DB_USER in $DB_CONTAINER"
echo "✅ Stack and database reachable ($DB_CONTAINER, db $DB_NAME)"

FREE_KB="$(df -Pk . | awk 'NR==2 {print $4}')"
[ "$FREE_KB" -ge $((MIN_FREE_GB * 1024 * 1024)) ] || die "less than ${MIN_FREE_GB}GB free disk"
echo "✅ Free disk: $((FREE_KB / 1024 / 1024))GB"

bash <(git show origin/main:scripts/lib/check-migrations.sh) "$CURRENT" "$TARGET" || die "migration guard"

REMOVED="$(git diff --name-only --diff-filter=D "$CURRENT" "$TARGET")"
[ -z "$REMOVED" ] || echo "ℹ️  $(echo "$REMOVED" | wc -l | tr -d ' ') file(s) removed by this release will be copied to $SAFE_ABS/git-removed/$TS first"

if [ "$CHECK_ONLY" -eq 1 ]; then echo; echo "✅ All checks passed. Nothing was changed (--check)."; exit 0; fi
if [ "$CURRENT" = "$TARGET" ]; then echo; echo "✅ $REF is already deployed. Nothing to do."; exit 0; fi

# ---------------------------------------------------------------- 2. protect files
step "2/7 Protect backups and any file git would remove"
mkdir -p "$SAFE_ABS/repo-backups"
for f in backups/*.sql backups/*.dump; do [ -f "$f" ] && cp -p -n "$f" "$SAFE_ABS/repo-backups/" || true; done
if [ -n "$REMOVED" ]; then
  while IFS= read -r f; do
    [ -e "$f" ] || continue
    mkdir -p "$SAFE_ABS/git-removed/$TS/$(dirname "$f")"
    cp -p "$f" "$SAFE_ABS/git-removed/$TS/$f"
  done <<< "$REMOVED"
fi
echo "✅ Copies kept in $SAFE_ABS"

# ---------------------------------------------------------------- 3. backup
step "3/7 Verified backup of the live database"
BACKUP="$SAFE_ABS/predeploy_${TS}_${CURRENT_NAME}_to_${REF}.dump"
DK exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" --format=custom --no-owner --no-privileges > "$BACKUP" || die "pg_dump failed"
[ -s "$BACKUP" ] || die "backup file is empty"
DK exec -i "$DB_CONTAINER" pg_restore --list < "$BACKUP" > /dev/null || die "backup file is not readable"
psql_db -c "$COUNTS_SQL" > "$SAFE_ABS/counts_before_$TS.txt"
echo "✅ $BACKUP ($(du -h "$BACKUP" | cut -f1)), $(wc -l < "$SAFE_ABS/counts_before_$TS.txt" | tr -d ' ') tables counted"

# ---------------------------------------------------------------- 4. checkout
step "4/7 Checkout $REF"
git checkout --quiet --detach "$TARGET" || die "git checkout failed (nothing deployed)"

healthy() {
  local i
  for i in $(seq 1 45); do
    if DC exec -T app node -e "Promise.all([fetch('http://127.0.0.1:3001/auth/me'),fetch('http://127.0.0.1:3000/login')]).then(([a,w])=>process.exit(a.status===401&&w.status<500?0:1)).catch(()=>process.exit(1))" >/dev/null 2>&1 \
      && [[ "$(DC exec -T app sh -c 'cd /app/backend && npx prisma migrate status' 2>/dev/null || true)" == *"Database schema is up to date"* ]]; then
      return 0
    fi
    sleep 4
  done
  return 1
}

rollback_code() {
  echo; echo "↩️  Rolling back the CODE to $CURRENT_NAME (data is untouched; migrations are additive and stay)"
  git checkout --quiet --detach "$CURRENT"
  DC up -d --build app
  if healthy; then echo "✅ Previous version $CURRENT_NAME is running again."; else echo "⛔ Previous version is not healthy either. Check: $DOCKER compose $COMPOSE_ARGS logs --tail 100 app"; fi
}

# ---------------------------------------------------------------- 5. build & start
step "5/7 Build and start (migrations run automatically on start)"
if ! DC up -d --build; then
  git checkout --quiet --detach "$CURRENT"
  record "BUILD FAILED, nothing deployed, backup $BACKUP"
  die "build/start failed; code is back at $CURRENT_NAME"
fi

# ---------------------------------------------------------------- 6. verify
step "6/7 Health, migrations and row counts"
if ! healthy; then
  DC logs --tail 60 app || true
  rollback_code
  record "UNHEALTHY, code rolled back, backup $BACKUP"
  die "$REF did not become healthy"
fi
echo "✅ API, frontend and migrations OK"

psql_db -c "$COUNTS_SQL" > "$SAFE_ABS/counts_after_$TS.txt"
LOST=0
while IFS='|' read -r table before; do
  after="$(grep "^$table|" "$SAFE_ABS/counts_after_$TS.txt" | cut -d'|' -f2)"
  if [ -z "$after" ] || [ "$after" -lt "$before" ]; then echo "⛔ $table: $before -> ${after:-MISSING} rows"; LOST=1; fi
done < "$SAFE_ABS/counts_before_$TS.txt"
if [ "$LOST" -eq 1 ]; then
  record "ROW COUNTS DECREASED after deploy, backup $BACKUP"
  echo
  echo "⛔ ALERT: rows decreased after deploying $REF. Do NOT make further changes."
  echo "   The pre-deploy backup is $BACKUP. Restoring it requires the owner's explicit approval."
  exit 2
fi
echo "✅ No table lost rows"

# ---------------------------------------------------------------- 7. done
step "7/7 Done"
record "OK, backup $BACKUP"
echo "✅ $REF deployed. Previous version: $CURRENT_NAME"
echo "   Rollback (code only, data stays): scripts/deploy-remote.sh $CURRENT_NAME"
echo "   Log: $LOG"
