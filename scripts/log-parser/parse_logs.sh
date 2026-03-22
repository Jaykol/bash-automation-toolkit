#!/usr/bin/env bash
# scripts/log-parser/parse_logs.sh
# Parses system logs and produces a daily error summary report.

# shellcheck disable=SC1091
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

LOG_SOURCE="${1:-/var/log/messages}"
REPORT_DIR="/var/log/toolkit-reports"
REPORT_FILE="$REPORT_DIR/log-report-$(date '+%F').txt"
PATTERN="error\|failed\|fatal\|critical"

generate_report() {
  mkdir -p "$REPORT_DIR"

  {
    echo "==========================================="
    echo " Daily Log Error Report — $(date '+%F %T')"
    echo "==========================================="
    echo ""
    echo "Source: $LOG_SOURCE"
    echo ""

    echo "--- Total error lines found ---"
    sudo grep -i "$PATTERN" "$LOG_SOURCE" | wc -l
    echo ""

    echo "--- Top offending processes ---"
    sudo grep -i "$PATTERN" "$LOG_SOURCE" | awk '{print $5}' | sort | uniq -c | sort -rn
    echo ""

    echo "--- Full error lines ---"
    sudo grep -i "$PATTERN" "$LOG_SOURCE"
    echo ""

    echo "==========================================="
    echo " End of report"
    echo "==========================================="
  } | tee "$REPORT_FILE"

  log_info "Report saved to $REPORT_FILE"
}

generate_report
