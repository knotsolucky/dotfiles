#!/usr/bin/env bash
set -euo pipefail
msg() {
  printf '%s\n' "$1" >&2
  command -v notify-send >/dev/null 2>&1 && notify-send "Eww bar" "$1" || true
}

if command -v gnome-calendar >/dev/null 2>&1; then
  exec gnome-calendar
fi
if command -v flatpak >/dev/null 2>&1 && flatpak info org.gnome.Calendar &>/dev/null; then
  exec flatpak run org.gnome.Calendar
fi
if command -v io.elementary.calendar >/dev/null 2>&1; then
  exec io.elementary.calendar
fi

msg "Install a calendar app, e.g. pacman -S gnome-calendar"
exit 1
