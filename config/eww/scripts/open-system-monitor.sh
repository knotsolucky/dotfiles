#!/usr/bin/env bash
set -euo pipefail
msg() {
  printf '%s\n' "$1" >&2
  command -v notify-send >/dev/null 2>&1 && notify-send "Eww bar" "$1" || true
}

if command -v gnome-system-monitor >/dev/null 2>&1; then
  exec gnome-system-monitor
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

msg "Install a system monitor GUI, e.g. pacman -S gnome-system-monitor"
exit 1
