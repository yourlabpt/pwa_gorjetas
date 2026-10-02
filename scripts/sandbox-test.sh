#!/usr/bin/env bash
# Sandbox test: runs the exact production Docker image of the current code
# against a copy of a production backup, restored into a NEW, EMPTY database
# of the isolated "pwa_sandbox" stack. Never deletes anything
# (README "REGRA N.º 1").
#
# Usage: scripts/sandbox-test.sh [--pull-latest] [--backup FILE] [--base REF] [--e2e] [--no-build]
#   --pull-latest  download the newest .dump from the droplet (needs deploy/deploy.env)
#   --backup FILE  use this .dump/.sql instead of the newest one found locally
#   --base REF     compare migrations against REF (default: last release-* tag, else origin/main)
#   --e2e          also run backend/test/e2e-employee-history.py (mutates the sandbox copy only)
#   --no-build     reuse the last sandbox image
#
# On success with a clean, committed tree, writes sandbox/passed_<commit>,
# which scripts/deploy-remote.sh requires before deploying that commit.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

BACKUP_FILE=""; PULL_LATEST=0; RUN_E2E=0; BUILD_FLAG="--build"; BASE_REF=""
while [ $# -gt 0 ]; do
  case "$1" in
    --pull-latest) PULL_LATEST=1 ;;
    --backup) BACKUP_FILE="${2:?}"; shift ;;
    --base) BASE_REF="${2:?}"; shift ;;
    --e2e) RUN_E2E=1 ;;
    --no-build) BUILD_FLAG="" ;;
    -h|--help) sed -n 2,17p "$0"; exit 0 ;;
    *) echo "Unknown option: $1"; exit 2 ;;
  esac
  shift
done

COMPOSE=(docker compose -f docker-compose.localtest.yml)
DB_CT=pwa_sandbox_db
APP_CT=pwa_sandbox_app
API=http://127.0.0.1:3301
WEB=http://127.0.0.1:3300
TS="$(date +%Y%m%d_%H%M%S)"
SANDBOX_DB="sandbox_$TS"
mkdir -p sandbox
REPORT="sandbox/report_$TS.txt"
exec > >(tee "$REPORT") 2>&1

step() { echo; echo "▶ $*"; }
fail() { echo; echo "⛔ SANDBOX FAILED: $*"; echo "Report: $REPORT"; exit 1; }
psql_sb() { docker exec "$DB_CT" psql -U app -d "$SANDBOX_DB" -v ON_ERROR_STOP=1 -tA "$@"; }

COUNTS_SQL="SELECT table_name || '|' || (xpath('/row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM public.%I', table_name), false, true, '')))[1]::text
FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1"

# ---------------------------------------------------------------- 1. code
step "1/8 Code under test"
COMMIT="$(git rev-parse HEAD)"
DIRTY="$(git status --porcelain --untracked-files=no | grep -v '\.DS_Store' || true)"
echo "Commit: $(git log -1 --format='%h %s')"
if [ -n "$DIRTY" ]; then
  echo "⚠️  Uncommitted changes are included in this test. No deploy marker will be written;"
  echo "   commit, tag and re-run before deploying."
fi

# ---------------------------------------------------------------- 2. migrations
step "2/8 Migration guard (README \"REGRA N.º 1\")"
git fetch origin --tags --quiet || echo "⚠️  git fetch failed, using local refs"
if [ -z "$BASE_REF" ]; then
  BASE_REF="$(git describe --tags --abbrev=0 --match 'release-*' 2>/dev/null || echo origin/main)"
fi
echo "Comparing against: $BASE_REF"
scripts/lib/check-migrations.sh "$BASE_REF" || fail "migration guard"

# ---------------------------------------------------------------- 3. unit tests
step "3/8 Backend unit tests"
( cd backend && { [ -d node_modules ] || npm ci; } && npm test --silent ) || fail "backend unit tests"
# Frontend date logic (day/period navigation). Needs Node 22.6+ to run TypeScript directly.
if [ "$(node -p 'process.versions.node.split(".")[0]')" -ge 23 ]; then
  node frontend/src/lib/dates.check.ts 2>/dev/null || fail "frontend date checks"
else
  echo "⚠️  Node < 23: skipped frontend/src/lib/dates.check.ts"
fi

# ---------------------------------------------------------------- 4. backup
step "4/8 Production backup to test with"
if [ "$PULL_LATEST" -eq 1 ]; then
  [ -f deploy/deploy.env ] || fail "deploy/deploy.env missing (copy deploy/deploy.env.example)"
  # shellcheck disable=SC1091
  . deploy/deploy.env
  REMOTE_DIR="${DEPLOY_BACKUP_DIR:-$DEPLOY_PATH/backups}"
  REMOTE_FILE="$(ssh "$DEPLOY_SSH" "ls -1t '$REMOTE_DIR'/*.dump 2>/dev/null | head -1")"
  [ -n "$REMOTE_FILE" ] || fail "no .dump found in $REMOTE_DIR on $DEPLOY_SSH"
  scp "$DEPLOY_SSH:$REMOTE_FILE" sandbox/ || fail "download of $REMOTE_FILE"
  BACKUP_FILE="sandbox/$(basename "$REMOTE_FILE")"
fi
if [ -z "$BACKUP_FILE" ]; then
  best=""; best_key=""
  for f in sandbox/*.dump sandbox/*.sql backups/*.dump backups/*.sql; do
    [ -f "$f" ] || continue
    key="$(basename "$f" | tr -cd '0-9' | cut -c1-14)"
    [ "${#key}" -eq 14 ] || continue
    if [ -z "$best_key" ] || [[ "$key" > "$best_key" ]] || { [ "$key" = "$best_key" ] && [[ "$f" == *.dump ]]; }; then
      best="$f"; best_key="$key"
    fi
  done
  BACKUP_FILE="$best"
fi
[ -n "$BACKUP_FILE" ] && [ -f "$BACKUP_FILE" ] || fail "no backup found (use --pull-latest or --backup FILE)"
echo "Backup: $BACKUP_FILE"
KEY="$(basename "$BACKUP_FILE" | tr -cd '0-9' | cut -c1-8)"
if [ "${#KEY}" -eq 8 ] && [ "$KEY" -lt "$(date -v-7d +%Y%m%d 2>/dev/null || date -d '7 days ago' +%Y%m%d)" ]; then
  echo "⚠️  This backup is older than 7 days. Prefer --pull-latest for a realistic test."
fi

# ---------------------------------------------------------------- 5. sandbox db
step "5/8 New, empty sandbox database: $SANDBOX_DB"
"${COMPOSE[@]}" up -d db_test
for _ in $(seq 1 30); do docker exec "$DB_CT" pg_isready -U app >/dev/null 2>&1 && break; sleep 2; done
docker exec "$DB_CT" pg_isready -U app >/dev/null || fail "sandbox Postgres not ready"
docker exec "$DB_CT" psql -U app -d postgres -v ON_ERROR_STOP=1 -qc "CREATE DATABASE \"$SANDBOX_DB\"" || fail "create $SANDBOX_DB"
case "$BACKUP_FILE" in
  *.dump) docker exec -i "$DB_CT" pg_restore -U app -d "$SANDBOX_DB" --no-owner --no-privileges < "$BACKUP_FILE" || echo "⚠️  pg_restore reported warnings" ;;
  *.sql)  docker exec -i "$DB_CT" psql -q -U app -d "$SANDBOX_DB" < "$BACKUP_FILE" > /dev/null || echo "⚠️  psql reported warnings" ;;
  *) fail "unsupported backup format: $BACKUP_FILE" ;;
esac
[ "$(psql_sb -c "SELECT to_regclass('public._prisma_migrations') IS NOT NULL")" = "t" ] || fail "restore produced no schema"
[ "$(psql_sb -c "SELECT count(*) > 0 FROM funcionarios")" = "t" ] || fail "restore produced no employees"

psql_sb -c "$COUNTS_SQL" > "sandbox/counts_before_$TS.txt"
echo "Restored $(wc -l < "sandbox/counts_before_$TS.txt" | tr -d ' ') tables, $(psql_sb -c 'SELECT count(*) FROM faturamento_diario_distribuicao') daily finance rows"

# Expected API reads for the 3 busiest restaurants, last 60 days of their data.
psql_sb -c "
WITH pick AS (
  SELECT \"restID\", max(data) AS mx FROM faturamento_diario_distribuicao
  GROUP BY 1 ORDER BY count(*) DESC LIMIT 3
), rows AS (
  SELECT p.\"restID\", p.mx, d.valor_pago
  FROM pick p
  JOIN faturamento_diario_distribuicao d ON d.\"restID\" = p.\"restID\" AND d.data BETWEEN p.mx - 60 AND p.mx
  JOIN faturamento_diario f ON f.\"restID\" = d.\"restID\" AND f.data = d.data AND f.ativo
)
SELECT coalesce(json_agg(json_build_object(
  'restID', p.\"restID\", 'from', (p.mx - 60)::text, 'to', p.mx::text,
  'rows', (SELECT count(*) FROM rows r WHERE r.\"restID\" = p.\"restID\"),
  'sum_pago', (SELECT coalesce(sum(r.valor_pago), 0) FROM rows r WHERE r.\"restID\" = p.\"restID\")::text
)), '[]') FROM pick p" > "sandbox/expected_$TS.json"

# ---------------------------------------------------------------- 6. app
step "6/8 Start the production image against $SANDBOX_DB"
if [ ! -f .env.localtest ]; then
  python3 - <<'PY'
import secrets
s = open('.env.localtest.example').read()
s = s.replace('JWT_SECRET=__RANDOM__', 'JWT_SECRET=' + secrets.token_hex(32), 1)
s = s.replace('SUPER_ADMIN_PASSWORD=__RANDOM__', 'SUPER_ADMIN_PASSWORD=Sbx-' + secrets.token_hex(8) + '-Aa1!', 1)
open('.env.localtest', 'w').write(s)
PY
  echo "Created .env.localtest (sandbox-only secrets, gitignored)"
fi
# shellcheck disable=SC2086
SANDBOX_DB="$SANDBOX_DB" "${COMPOSE[@]}" up -d $BUILD_FLAG app_test || fail "build/start of the app image"

echo "Waiting for the API (migrations run on start)..."
ready=0
for _ in $(seq 1 90); do
  code="$(curl -s -o /dev/null -w '%{http_code}' "$API/auth/me" || true)"
  [ "$code" = "401" ] && ready=1 && break
  if [[ "$(docker logs "$APP_CT" 2>&1 || true)" == *"Migration failed"* ]]; then
    docker logs --tail 40 "$APP_CT"; fail "migrations failed on the production copy"
  fi
  sleep 4
done
[ "$ready" -eq 1 ] || { docker logs --tail 60 "$APP_CT"; fail "API did not come up"; }

# ---------------------------------------------------------------- 7. data
step "7/8 Migrations applied and no data lost"
MIG_STATUS="$(docker exec "$APP_CT" sh -c 'cd /app/backend && npx prisma migrate status' 2>&1 || true)"
echo "$MIG_STATUS" | tail -3
[[ "$MIG_STATUS" == *"Database schema is up to date"* ]] || fail "migrations pending"

psql_sb -c "$COUNTS_SQL" > "sandbox/counts_after_$TS.txt"
data_ok=1
while IFS='|' read -r table before; do
  after="$(grep "^$table|" "sandbox/counts_after_$TS.txt" | cut -d'|' -f2)"
  if [ -z "$after" ]; then echo "⛔ table $table disappeared"; data_ok=0
  elif [ "$after" -lt "$before" ]; then echo "⛔ $table: $before -> $after rows (DATA LOST)"; data_ok=0
  elif [ "$after" -gt "$before" ]; then echo "ℹ️  $table: $before -> $after rows"
  fi
done < "sandbox/counts_before_$TS.txt"
grep -v -F -f <(cut -d'|' -f1 "sandbox/counts_before_$TS.txt" | sed 's/$/|/') "sandbox/counts_after_$TS.txt" | sed 's/^/ℹ️  new table: /' || true
[ "$data_ok" -eq 1 ] || fail "row counts decreased after starting the new version"
echo "✅ No table lost rows"

# ---------------------------------------------------------------- 8. smoke
step "8/8 Smoke test (API reads must equal the database)"
SB_EMAIL="$(grep '^SUPER_ADMIN_EMAIL=' .env.localtest | cut -d= -f2-)"
SB_PASS="$(grep '^SUPER_ADMIN_PASSWORD=' .env.localtest | cut -d= -f2-)"
python3 scripts/smoke-test.py --api "$API" --web "$WEB" --email "$SB_EMAIL" --password "$SB_PASS" \
  --expected "sandbox/expected_$TS.json" || fail "smoke test"

if [ "$RUN_E2E" -eq 1 ]; then
  step "Extra: employee (de)activation regression scenario"
  E2E_BASE="$API" E2E_EMAIL="$SB_EMAIL" E2E_PASSWORD="$SB_PASS" \
    python3 backend/test/e2e-employee-history.py "$(date +%Y-%m-%d)" \
    "$(date -v+1d +%Y-%m-%d 2>/dev/null || date -d tomorrow +%Y-%m-%d)" || fail "e2e scenario"
fi

echo
echo "✅ SANDBOX PASSED for $(git log -1 --format='%h %s')"
if [ -z "$DIRTY" ]; then
  echo "$TS $BACKUP_FILE $SANDBOX_DB" > "sandbox/passed_$COMMIT"
  echo "   Deploy marker written: sandbox/passed_$COMMIT"
fi
echo "   Explore it: $WEB  (login $SB_EMAIL, password in .env.localtest)"
echo "   Database kept: $SANDBOX_DB (sandbox databases are never deleted)"
echo "   Stop the sandbox when done: docker compose -f docker-compose.localtest.yml stop"
echo "   Report: $REPORT"
