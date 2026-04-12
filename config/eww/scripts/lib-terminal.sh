# shellcheck shell=bash
# Sourced by eww bar scripts — run a command in the first available terminal emulator.

eww_terminal_run() {
  (($#)) || return 1
  if command -v kitty >/dev/null 2>&1; then exec kitty -e "$@"; fi
  if command -v alacritty >/dev/null 2>&1; then exec alacritty -e "$@"; fi
  if command -v ghostty >/dev/null 2>&1; then exec ghostty -e "$@"; fi
  if command -v foot >/dev/null 2>&1; then exec foot -e "$@"; fi
  return 1
}
