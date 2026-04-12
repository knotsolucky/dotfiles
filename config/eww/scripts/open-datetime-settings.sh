#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib-terminal.sh
source "$SCRIPT_DIR/lib-terminal.sh"

msg() {
  printf '%s\n' "$1" >&2
  command -v notify-send >/dev/null 2>&1 && notify-send "Eww bar" "$1" || true
}

if command -v systemsettings >/dev/null 2>&1; then
  exec systemsettings kcm_clock
fi

if command -v timedatectl >/dev/null 2>&1; then
  eww_terminal_run bash -lc 'timedatectl status; echo; echo "Set zone: sudo timedatectl set-timezone <Region/City>"; read -rn1 -p "Close… " _' || true
fi

exec bash "$SCRIPT_DIR/open-calendar.sh"
