#!/bin/bash

# Phase 1 MVP Setup Script
# Starts all services and runs migrations + seed

set -e

echo "🚀 Starting PWA Restaurantes Lisboa - Phase 1 MVP Setup"
echo ""

# Ensure common binary paths are available (e.g., snap installations on Linux)
export PATH="$PATH:/usr/local/bin:/usr/bin:/snap/bin"

DB_CONTAINER_NAME="pwa_restaurantes_db"
DB_NAME="${POSTGRES_DB:-app}"
DB_USER="${POSTGRES_USER:-app}"
BACKUP_DIR="./backups"

# Requested bootstrap super admin (can still be overridden by env vars)
SUPER_ADMIN_NAME="${SUPER_ADMIN_NAME:-Super Admin}"
SUPER_ADMIN_EMAIL="${SUPER_ADMIN_EMAIL:-superadmin@yourlab.com}"
SUPER_ADMIN_PASSWORD="${SUPER_ADMIN_PASSWORD:-Super@admin321*}"

# Docker command (may switch to sudo docker if needed)
DOCKER_CMD=(docker)

find_latest_backup() {
  local best_file=""
  local best_key=""
  local best_ext=""

  for file in "$BACKUP_DIR"/*.dump "$BACKUP_DIR"/*.sql; do
    [ -f "$file" ] || continue

    local base
    local key
    local ext
    base="$(basename "$file")"
    key="$(echo "$base" | tr -cd '0-9' | cut -c1-14)"
    ext="${file##*.}"

    # Skip files without a parseable timestamp key.
    [ "${#key}" -eq 14 ] || continue

    if [ -z "$best_key" ] || [[ "$key" > "$best_key" ]]; then
      best_file="$file"
      best_key="$key"
      best_ext="$ext"
    elif [ "$key" = "$best_key" ] && [ "$ext" = "dump" ] && [ "$best_ext" != "dump" ]; then
      best_file="$file"
      best_ext="$ext"
    fi
  done

  echo "$best_file"
}

restore_backup() {
  local restore_file="$1"
  local file_ext="${restore_file##*.}"

  echo "   - Restoring backup: $(basename "$restore_file")"

  # Drop existing active connections before restore.
  "${DOCKER_CMD[@]}" exec "$DB_CONTAINER_NAME" psql -U "$DB_USER" -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();" >/dev/null 2>&1 || true

  if [ "$file_ext" = "dump" ]; then
    cat "$restore_file" | "${DOCKER_CMD[@]}" exec -i "$DB_CONTAINER_NAME" pg_restore \
      -U "$DB_USER" \
      -d "$DB_NAME" \
      --clean --if-exists --no-owner --no-privileges
  else
    cat "$restore_file" | "${DOCKER_CMD[@]}" exec -i "$DB_CONTAINER_NAME" psql \
      -U "$DB_USER" \
      -d "$DB_NAME"
  fi
}

# Check Docker
echo "1️⃣  Checking Docker..."
if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Docker CLI was not found in PATH."
  echo "   Current PATH: $PATH"
  echo "   If Docker is installed, restart your terminal/session and try again."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  if command -v sudo >/dev/null 2>&1 && [ -t 0 ]; then
    echo "⚠️  Docker is not accessible by current user. Trying sudo access..."
    if sudo -v >/dev/null 2>&1 && sudo docker info >/dev/null 2>&1; then
      DOCKER_CMD=(sudo docker)
      echo "⚠️  Running Docker commands with sudo for this setup run."
      echo "   Permanent fix: sudo usermod -aG docker $USER && newgrp docker"
    else
      echo "❌ Docker sudo access also failed."
      echo "   Make sure Docker daemon is running: sudo systemctl start docker"
      echo "   Then add your user to docker group (and re-login): sudo usermod -aG docker $USER"
      exit 1
    fi
  else
    echo "❌ Docker is installed, but cannot be accessed."
    echo "   Possible causes: Docker daemon is stopped, or your user lacks Docker permissions."
    echo "   Try: sudo systemctl start docker"
    echo "   Then add your user to docker group (and re-login): sudo usermod -aG docker $USER"
    exit 1
  fi
fi

# Resolve Docker Compose command (v2 plugin preferred, v1 fallback)
if "${DOCKER_CMD[@]}" compose version >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD=("${DOCKER_CMD[@]}" compose)
elif command -v docker-compose >/dev/null 2>&1; then
  if [ "${DOCKER_CMD[0]}" = "sudo" ]; then
    DOCKER_COMPOSE_CMD=(sudo docker-compose)
  else
    DOCKER_COMPOSE_CMD=(docker-compose)
  fi
else
  echo "❌ Docker Compose is not available. Install Docker Compose v2 (recommended) or docker-compose v1."
  exit 1
fi

COMPOSE_DISPLAY="${DOCKER_COMPOSE_CMD[*]}"

echo "✅ Docker is ready"
echo ""

# Clean up old volumes
echo "2️⃣  Cleaning up old database..."
"${DOCKER_COMPOSE_CMD[@]}" down -v 2>/dev/null || true

# Start PostgreSQL
echo "3️⃣  Starting PostgreSQL..."
"${DOCKER_COMPOSE_CMD[@]}" up -d
sleep 10

if [ "$("${DOCKER_CMD[@]}" ps -q -f name="$DB_CONTAINER_NAME")" ]; then
  echo "✅ PostgreSQL is running"
else
  echo "❌ PostgreSQL failed to start"
  exit 1
fi

echo ""
echo "4️⃣  Setting up Backend..."
cd backend

# Install dependencies
if [ ! -d "node_modules" ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

echo "✅ Dependencies installed"

# Setup database
echo ""
echo "5️⃣  Setting up Database..."
LATEST_BACKUP="$(find_latest_backup)"

if [ -n "$LATEST_BACKUP" ]; then
  echo "   - Latest backup found. Loading current database snapshot..."
  restore_backup "$LATEST_BACKUP"
else
  echo "   - No backup found. Running migrations..."
  npx prisma migrate deploy

  echo "   - Seeding data..."
  npx prisma db seed
fi

echo ""
echo "   - Ensuring SUPER_ADMIN bootstrap account..."
export SUPER_ADMIN_NAME SUPER_ADMIN_EMAIL SUPER_ADMIN_PASSWORD
npx ts-node -e "const { NestFactory } = require('@nestjs/core'); const { AppModule } = require('./src/app.module'); (async () => { const app = await NestFactory.createApplicationContext(AppModule, { logger: false }); await app.close(); })().catch((error) => { console.error(error); process.exit(1); });"

echo "✅ Database setup complete"

cd ..

echo ""
echo "6️⃣  Setting up Frontend..."
cd frontend

if [ ! -d "node_modules" ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

echo "✅ Frontend ready"

cd ..

echo ""
echo "========================================="
echo "🎉 Setup Complete!"
echo "========================================="
echo ""
echo "📋 Next steps:"
echo ""
echo "Terminal 1 - Backend:"
echo "  cd backend && npm run start:dev"
echo "  (Server will run on http://localhost:3001)"
echo ""
echo "Terminal 2 - Frontend:"
echo "  cd frontend && npm run dev"
echo "  (App will run on http://localhost:3000)"
echo ""
echo "📱 Open http://localhost:3000 in your browser"
echo ""
echo "🗃️  Database source:"
if [ -n "${LATEST_BACKUP:-}" ]; then
  echo "   - Restored from: $(basename "$LATEST_BACKUP")"
else
  echo "   - Fresh migration + seed"
fi
echo ""
echo "🔐 SUPER_ADMIN account synced:"
echo "   - Email: $SUPER_ADMIN_EMAIL"
echo "   - Password: $SUPER_ADMIN_PASSWORD"
echo ""
echo "🛑 To stop:"
echo "  $COMPOSE_DISPLAY down"
echo ""
