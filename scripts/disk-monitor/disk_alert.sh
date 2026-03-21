#!/usr/bin/env bash
# scripts/disk-monitor/disk_alert.sh
# Checks disk usage and warns when filesystems exceed the threshold.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

THRESHOLD=80

log_info "Starting disk usage check (threshold: ${THRESHOLD}%)"

ALERT_COUNT=0

df -P | grep -v tmpfs | tail -n +2 | awk '{print $5, $6}' | tr -d '%' | while read -r usage mountpoint; do
  if [[ "$usage" -ge "$THRESHOLD" ]]; then
    log_warn "$mountpoint is at ${usage}% capacity"
    (( ALERT_COUNT++ )) || true
  fi
done

if [[ "$ALERT_COUNT" -eq 0 ]]; then
  log_info "All filesystems OK."
fi

log_info "Disk check complete."
