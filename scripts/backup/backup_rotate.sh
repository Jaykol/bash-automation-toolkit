#!/usr/bin/bash
# scripts/backup/backup_rotate.sh
#creates a dated backup of a source directory and rotates old backups.

#shellcheck disable=SC1091

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

SOURCE_DIR="${1:-/etc}"
BACKUP_DIR="${2:-/var/backups/toolkit}"
RETENTION_DAYS=7
DATE=$(date '+%F')
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

create_backup() {
  mkdir -p "$BACKUP_DIR"
  log_info "Backing up '$SOURCE_DIR' to '$BACKUP_FILE'..."

  tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>/dev/null || true

  if [[ -f "$BACKUP_FILE" ]]; then
    log_info "Backup created: $BACKUP_FILE ($(du -sh "$BACKUP_FILE" | cut -f1))"
  else
    die "Backup failed for '$SOURCE_DIR'"
  fi
}

rotate_backups() {
  log_info "Rotating backups older than $RETENTION_DAYS days in '$BACKUP_DIR'..."
  local count
  count=$(find "$BACKUP_DIR" -name "*.tar.gz" -mtime +"$RETENTION_DAYS" | wc -l)

  if [[ "$count" -gt 0 ]]; then
    find "$BACKUP_DIR" -name "*.tar.gz" -mtime +"$RETENTION_DAYS" -delete
    log_warn "$count old backup(s) deleted."
  else
    log_info "No old backups to rotate."
  fi
}

create_backup
rotate_backups
