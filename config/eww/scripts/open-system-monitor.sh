#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib-terminal.sh
source "$SCRIPT_DIR/lib-terminal.sh"

msg() {
  printf '%s\n' "$1" >&2
  command -v notify-send >/dev/null 2>&1 && notify-send "Eww bar" "$1" || true
}

if command -v btop >/dev/null 2>&1; then
  eww_terminal_run btop || true
fi
if command -v plasma-systemmonitor >/dev/null 2>&1; then
  exec plasma-systemmonitor
fi
if command -v flatpak >/dev/null 2>&1; then
  if flatpak info io.missioncenter.MissionCenter &>/dev/null; then
    exec flatpak run io.missioncenter.MissionCenter
  fi
  if flatpak info io.bassi.Resources &>/dev/null; then
    exec flatpak run io.bassi.Resources
  fi
fi

msg "No system monitor found. Install btop (script default), a terminal, or a Flatpak like Mission Center."
exit 1
