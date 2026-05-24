#!/bin/bash

# Database Backup & Restore Utility
# Works with Docker PostgreSQL container

set -euo pipefail

CONTAINER_NAME="${CONTAINER_NAME:-pwa_gorjetas-db-1}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
ENV_FILE="${ENV_FILE:-.env.production}"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"

DB_NAME="${POSTGRES_DB:-app}"
DB_USER="${POSTGRES_USER:-app}"

if [ -f "$ENV_FILE" ]; then
  # shellcheck disable=SC2046
  export $(grep -E '^(POSTGRES_USER|POSTGRES_DB)=' "$ENV_FILE" | xargs -r)
  DB_NAME="${POSTGRES_DB:-$DB_NAME}"
  DB_USER="${POSTGRES_USER:-$DB_USER}"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

show_help() {
  echo "Database Backup & Restore Utility"
  echo ""
  echo "Usage: ./db-backup-restore.sh [command] [options]"
  echo ""
  echo "Commands:"
  echo "  backup              Create rollback-safe backups (.sql + .dump)"
  echo "  cleanup             Remove backups older than the retention window"
  echo "  restore <file>      Restore database from a .sql or .dump file"
  echo "  list                List all available backups"
  echo "  help                Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./db-backup-restore.sh backup"
  echo "  ./db-backup-restore.sh restore backups/backup_2026-02-10_10-22-00.sql"
  echo "  ./db-backup-restore.sh restore backups/backup_2026-02-10_10-22-00.dump"
  echo "  ./db-backup-restore.sh list"
}

check_container() {
  if ! docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
    echo -e "${RED}❌ Error: PostgreSQL container '$CONTAINER_NAME' is not running${NC}"
    echo "Start it with: docker-compose up -d"
    exit 1
  fi
}

backup_database() {
  check_container

  TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
  SQL_BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"
  DUMP_BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.dump"

  echo -e "${YELLOW}📦 Creating plain SQL backup...${NC}"
  docker exec "$CONTAINER_NAME" pg_dump \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    --clean --if-exists --no-owner --no-privileges > "$SQL_BACKUP_FILE"

  echo -e "${YELLOW}📦 Creating custom-format backup...${NC}"
  docker exec "$CONTAINER_NAME" pg_dump \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    --format=custom --no-owner --no-privileges > "$DUMP_BACKUP_FILE"

  SQL_SIZE=$(du -h "$SQL_BACKUP_FILE" | cut -f1)
  DUMP_SIZE=$(du -h "$DUMP_BACKUP_FILE" | cut -f1)

  echo -e "${GREEN}✅ Backups created successfully!${NC}"
  echo -e "   SQL : $SQL_BACKUP_FILE ($SQL_SIZE)"
  echo -e "   DUMP: $DUMP_BACKUP_FILE ($DUMP_SIZE)"
  echo -e "${YELLOW}💡 Use .dump for safest post-migration rollback.${NC}"

  cleanup_old_backups
}

cleanup_old_backups() {
  if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}No backup directory found at $BACKUP_DIR${NC}"
    return 0
  fi

  mapfile -t OLD_BACKUPS < <(find "$BACKUP_DIR" -maxdepth 1 -type f \( -name '*.sql' -o -name '*.dump' \) -mtime +"$BACKUP_RETENTION_DAYS" -print -delete)

  if [ "${#OLD_BACKUPS[@]}" -eq 0 ]; then
    echo -e "${GREEN}🧹 No backups older than $BACKUP_RETENTION_DAYS days were found.${NC}"
    return 0
  fi

  echo -e "${GREEN}🧹 Removed backups older than $BACKUP_RETENTION_DAYS days:${NC}"
  for file in "${OLD_BACKUPS[@]}"; do
    echo -e "   - $file"
  done
}

restore_database() {
  check_container

  RESTORE_FILE="$1"

  if [ -z "$RESTORE_FILE" ]; then
    echo -e "${RED}❌ Error: Please specify a backup file to restore${NC}"
    echo "Usage: ./db-backup-restore.sh restore <file>"
    exit 1
  fi

  if [ ! -f "$RESTORE_FILE" ]; then
    echo -e "${RED}❌ Error: File '$RESTORE_FILE' not found${NC}"
    exit 1
  fi

  FILE_EXT="${RESTORE_FILE##*.}"
  if [[ "$FILE_EXT" != "sql" && "$FILE_EXT" != "dump" ]]; then
    echo -e "${RED}❌ Error: Unsupported restore format '$FILE_EXT' (use .sql or .dump)${NC}"
    exit 1
  fi

  echo -e "${YELLOW}⚠️  WARNING: This will replace all data in the database!${NC}"
  echo -e "   Database: $DB_NAME"
  echo -e "   File: $RESTORE_FILE"
  echo ""
  read -p "Are you sure you want to continue? (yes/no): " -r
  echo

  if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restore cancelled."
    exit 0
  fi

  echo -e "${YELLOW}🔄 Restoring database...${NC}"

  # Drop existing connections
  docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();" > /dev/null 2>&1 || true

  if [ "$FILE_EXT" = "dump" ]; then
    cat "$RESTORE_FILE" | docker exec -i "$CONTAINER_NAME" pg_restore \
      -U "$DB_USER" \
      -d "$DB_NAME" \
      --clean --if-exists --no-owner --no-privileges
  else
    cat "$RESTORE_FILE" | docker exec -i "$CONTAINER_NAME" psql \
      -U "$DB_USER" \
      -d "$DB_NAME"
  fi

  echo -e "${GREEN}✅ Database restored successfully!${NC}"
  echo ""
  echo -e "${YELLOW}💡 Remember to restart your application:${NC}"
  echo "   docker compose -f docker-compose.prod.yml -f docker-compose.tunnel.yml restart app"
}

list_backups() {
  if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A $BACKUP_DIR/*.sql $BACKUP_DIR/*.dump 2>/dev/null)" ]; then
    echo -e "${YELLOW}No backups found in $BACKUP_DIR${NC}"
    exit 0
  fi

  echo "Available backups:"
  echo ""

  for file in "$BACKUP_DIR"/*.sql "$BACKUP_DIR"/*.dump; do
    if [ -f "$file" ]; then
      FILE_SIZE=$(du -h "$file" | cut -f1)
      FILE_DATE=$(stat -c "%y" "$file" 2>/dev/null | cut -d'.' -f1 || stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file" 2>/dev/null)
      echo -e "  📄 $(basename "$file")"
      echo -e "     Size: $FILE_SIZE | Modified: $FILE_DATE"
      echo ""
    fi
  done
}

# Main script logic
case "$1" in
  backup)
    backup_database
    ;;
  cleanup)
    cleanup_old_backups
    ;;
  restore)
    restore_database "$2"
    ;;
  list)
    list_backups
    ;;
  help|--help|-h|"")
    show_help
    ;;
  *)
    echo -e "${RED}Unknown command: $1${NC}"
    echo ""
    show_help
    exit 1
    ;;
esac
