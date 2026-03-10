#!/bin/sh
set -e

BACKEND_PORT="${PORT:-3001}"
FRONTEND_PORT="${FRONTEND_PORT:-3000}"
MIGRATE_ON_START="${MIGRATE_ON_START:-true}"
MIGRATE_STRICT="${MIGRATE_STRICT:-false}"

# Apply any pending database migrations before starting services
if [ "$MIGRATE_ON_START" = "true" ]; then
  echo "Running database migrations..."
  if (cd /app/backend && npx prisma migrate deploy); then
    echo "Migrations complete."
  else
    if [ "$MIGRATE_STRICT" = "true" ]; then
      echo "Migration failed and MIGRATE_STRICT=true, exiting."
      exit 1
    fi
    echo "Migration failed, but continuing startup (MIGRATE_STRICT=false)."
  fi
fi

PORT="$BACKEND_PORT" node /app/backend/dist/main.js &
BACK_PID=$!

cd /app/frontend
PORT="$FRONTEND_PORT" HOSTNAME="0.0.0.0" npm run start -- --hostname 0.0.0.0 --port "$FRONTEND_PORT" &
FRONT_PID=$!

trap "kill $BACK_PID $FRONT_PID" INT TERM
# Wait for both processes; container exits when both have finished
wait $BACK_PID
wait $FRONT_PID
