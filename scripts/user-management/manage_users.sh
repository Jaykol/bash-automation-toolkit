#!/usr/bin/env bash
# scripts/user-management/manage_users.sh
# Manages user accounts — create, remove, and group assignment.

# shellcheck disable=SC1091
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

require_root

# ── Functions ──────────────────────────────────────────────────────

create_user() {
  local username="$1"
  if id "$username" &>/dev/null; then
    log_warn "User '$username' already exists. Skipping."
    return 1
  fi
  useradd -m "$username" && log_info "User '$username' created with home directory."
}

remove_user() {
  local username="$1"
  if ! id "$username" &>/dev/null; then
    log_warn "User '$username' does not exist. Skipping."
    return 1
  fi
  userdel -r "$username" && log_info "User '$username' and home directory removed."
}

add_to_group() {
  local username="$1"
  local group="$2"
  if ! getent group "$group" &>/dev/null; then
    log_error "Group '$group' does not exist."
    return 1
  fi
  usermod -aG "$group" "$username" && log_info "User '$username' added to group '$group'."
}

# ── Main ───────────────────────────────────────────────────────────

usage() {
  echo "Usage: $0 [create|remove|addgroup] username [group]"
  exit 1
}

[[ $# -lt 2 ]] && usage

case "$1" in
  create)   create_user "$2" ;;
  remove)   remove_user "$2" ;;
  addgroup) add_to_group "$2" "$3" ;;
  *)        usage ;;
esac
