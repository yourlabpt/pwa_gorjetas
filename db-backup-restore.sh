#!/bin/bash

# Database Backup & Restore Utility
# Works with Docker PostgreSQL container

set -e

CONTAINER_NAME="pwa_gorjetas-db-1"
DB_NAME="app"
DB_USER="app"
BACKUP_DIR="./backups"

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
  echo "  backup              Create a backup of the database"
  echo "  restore <file>      Restore database from a .sql file"
  echo "  list                List all available backups"
  echo "  help                Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./db-backup-restore.sh backup"
  echo "  ./db-backup-restore.sh restore backups/backup_2026-02-10.sql"
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
  BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"
  
  echo -e "${YELLOW}📦 Creating backup...${NC}"
  
  docker exec "$CONTAINER_NAME" pg_dump -U "$DB_USER" -d "$DB_NAME" --clean --if-exists > "$BACKUP_FILE"
  
  if [ $? -eq 0 ]; then
    FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo -e "${GREEN}✅ Backup created successfully!${NC}"
    echo -e "   File: $BACKUP_FILE"
    echo -e "   Size: $FILE_SIZE"
  else
    echo -e "${RED}❌ Backup failed${NC}"
    exit 1
  fi
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
  
  # Restore the database
  cat "$RESTORE_FILE" | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Database restored successfully!${NC}"
    echo ""
    echo -e "${YELLOW}💡 Remember to restart your application:${NC}"
    echo "   docker-compose restart app"
    echo "   OR if running locally: restart your backend server"
  else
    echo -e "${RED}❌ Restore failed${NC}"
    exit 1
  fi
}

list_backups() {
  if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A $BACKUP_DIR/*.sql 2>/dev/null)" ]; then
    echo -e "${YELLOW}No backups found in $BACKUP_DIR${NC}"
    exit 0
  fi
  
  echo "Available backups:"
  echo ""
  
  for file in "$BACKUP_DIR"/*.sql; do
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
