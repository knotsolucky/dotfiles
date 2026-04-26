#!/usr/bin/env bash
# Dotfiles hook: hyprland.conf expects hyprsplit (split:* + plugin { hyprsplit }).
# Safe to run after every config sync; hyprpm is idempotent for add/enable.
set -u

if ! command -v hyprpm >/dev/null 2>&1; then
  printf '%s\n' "ensure-hyprsplit: hyprpm not on PATH (install hyprland). See documentation/hyprsplit.md" >&2
  exit 0
fi

hyprpm update || printf '%s\n' "ensure-hyprsplit: hyprpm update failed (network/headers?)" >&2
yes | hyprpm add https://github.com/shezdy/hyprsplit || true
hyprpm enable hyprsplit || true
hyprpm reload -n || true
printf '%s\n' "ensure-hyprsplit: hyprsplit add/enable/reload attempted."
