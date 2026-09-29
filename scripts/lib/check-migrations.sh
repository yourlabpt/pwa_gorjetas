#!/usr/bin/env bash
# Blocks migrations that could destroy or overwrite data (README "REGRA N.º 1").
#
# Usage: check-migrations.sh <base-ref> [<target-ref>]
#   Without <target-ref> the working tree is checked (used by the sandbox).
# Env:   APPROVED_MIGRATIONS="folder_a folder_b"  owner-approved exceptions.
# Exit:  0 = safe, 1 = blocked.
set -euo pipefail

BASE="${1:?base ref required}"
TARGET="${2:-}"
MIG_DIR="backend/prisma/migrations"
APPROVED=" ${APPROVED_MIGRATIONS:-} "

# Statements that remove or overwrite data/schema. `ON DELETE CASCADE` and
# `ON UPDATE CASCADE` are not matched.
DANGER='(^|[^A-Za-z_])(DROP|TRUNCATE|RENAME)([^A-Za-z_]|$)|DELETE[[:space:]]+FROM|UPDATE[[:space:]]+"?[A-Za-z_]+"?[[:space:]]+SET|ALTER[[:space:]]+COLUMN[^;]*TYPE'

if [ -n "$TARGET" ]; then
  CHANGES="$(git diff --name-status "$BASE" "$TARGET" -- "$MIG_DIR")"
else
  CHANGES="$(git diff --name-status "$BASE" -- "$MIG_DIR"; git ls-files --others --exclude-standard -- "$MIG_DIR" | sed 's/^/A\t/')"
fi

read_file() {
  if [ -n "$TARGET" ]; then git show "$TARGET:$1"; else cat "$1"; fi
}

blocked=0
checked=0
while IFS=$'\t' read -r status path _; do
  [ -n "${status:-}" ] || continue
  case "$path" in *.sql) ;; *) continue ;; esac
  name="$(basename "$(dirname "$path")")"
  case "$status" in
    A)
      checked=$((checked + 1))
      hits="$(read_file "$path" | sed 's/--.*$//' | grep -Ein "$DANGER" || true)"
      if [ -n "$hits" ]; then
        if [[ "$APPROVED" == *" $name "* ]]; then
          echo "⚠️  $name contains destructive statements but is listed in APPROVED_MIGRATIONS:"
          echo "$hits" | sed 's/^/      /'
        else
          echo "⛔ $name contains statements that can delete or overwrite data:"
          echo "$hits" | sed 's/^/      /'
          blocked=1
        fi
      else
        echo "✅ $name is additive"
      fi
      ;;
    D)
      # Rolling back to an older release: the migration stays applied in the
      # database and the older code ignores the extra table/column.
      echo "ℹ️  $name is not in the target release (rollback); it stays applied in the database"
      ;;
    *)
      echo "⛔ $path was modified ($status). Applied migrations must never change."
      blocked=1
      ;;
  esac
done <<< "$CHANGES"

[ "$checked" -gt 0 ] || [ "$blocked" -eq 1 ] || echo "✅ No new migrations"
if [ "$blocked" -eq 1 ]; then
  echo "⛔ Blocked by README \"REGRA N.º 1\". Needs explicit owner approval, a backup and a sandbox rehearsal,"
  echo "   then the folder name in APPROVED_MIGRATIONS."
  exit 1
fi
