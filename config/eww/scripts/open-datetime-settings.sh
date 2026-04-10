#!/usr/bin/env bash
set -euo pipefail
msg() {
  printf '%s\n' "$1" >&2
  command -v notify-send >/dev/null 2>&1 && notify-send "Eww bar" "$1" || true
}

if command -v gnome-control-center >/dev/null 2>&1; then
  exec gnome-control-center datetime
fi
if command -v systemsettings >/dev/null 2>&1; then
  exec systemsettings kcm_clock
fi

exec bash ~/.config/eww/scripts/open-calendar.sh
