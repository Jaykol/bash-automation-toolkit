#!/usr/bin/env bash
# lib/common.sh — shared utilities for the bash automation toolkit

set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m'

# ── Log file (can be overridden by individual scripts) ─────────────
LOG_FILE="${LOG_FILE:-/var/log/toolkit.log}"

# ── Logging functions ──────────────────────────────────────────────
log_info()  { echo -e "${GREEN}[INFO]${NC}  $(date '+%F %T') — $*" | tee -a "$LOG_FILE"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $(date '+%F %T') — $*" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $(date '+%F %T') — $*" | tee -a "$LOG_FILE" >&2; }

# ── Exit with error message ────────────────────────────────────────
die() {
  log_error "$1"
  exit "${2:-1}"
}

# ── Guards ─────────────────────────────────────────────────────────
require_root() {
  [[ $EUID -eq 0 ]] || die "This script must be run as root."
}

require_cmd() {
  command -v "$1" &>/dev/null || die "Required command not found: $1"
}
