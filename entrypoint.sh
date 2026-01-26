#!/bin/sh
set -e

BACKEND_PORT="${PORT:-3001}"
FRONTEND_PORT="${FRONTEND_PORT:-3000}"

PORT="$BACKEND_PORT" node /app/backend/dist/main.js &
BACK_PID=$!

cd /app/frontend
PORT="$FRONTEND_PORT" HOSTNAME="0.0.0.0" npm run start -- --hostname 0.0.0.0 --port "$FRONTEND_PORT" &
FRONT_PID=$!

trap "kill $BACK_PID $FRONT_PID" INT TERM
# Wait for both processes; container exits when both have finished
wait $BACK_PID
wait $FRONT_PID
