#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib-terminal.sh
source "$SCRIPT_DIR/lib-terminal.sh"

msg() {
  printf '%s\n' "$1" >&2
  command -v notify-send >/dev/null 2>&1 && notify-send "Eww bar" "$1" || true
}

if command -v flatpak >/dev/null 2>&1; then
  for fp in org.kde.merkuro org.kde.kalendar; do
    if flatpak info "$fp" &>/dev/null; then
      exec flatpak run "$fp"
    fi
  done
fi
if command -v io.elementary.calendar >/dev/null 2>&1; then
  exec io.elementary.calendar
fi

if command -v cal >/dev/null 2>&1; then
  eww_terminal_run bash -lc 'cal -n 3; echo; read -rn1 -p "Close… " _' || true
fi

msg "No calendar UI found. Install Flatpak org.kde.kalendar, elementary Calendar, or use cal in a terminal."
exit 1
