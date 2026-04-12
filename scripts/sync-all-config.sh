#!/usr/bin/env bash
# Sync every entry under repo config/ into $XDG_CONFIG_HOME (~/.config by default).
# No app whitelist: each immediate child of config/ is mirrored (directories merged via cp -a;
# top-level files under config/ are copied as ~/.config/<filename>).
# Optional: DOTFILES_SYNC_EXCLUDE — space-separated basenames to skip (dirs and top-level files).
# On Darwin, if DOTFILES_SYNC_EXCLUDE is unset, defaults skip Hyprland / Wayland bar stack (see below).
# Called by arch-linux/install.sh, macos/install.sh (after packages/brew), and scripts/restow-config.sh.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/config"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}"

# macOS: avoid copying Linux compositor / session configs (still sync nvim, kitty, etc.).
DEFAULT_MACOS_EXCLUDES="hypr HyprPaper waybar swaync wlogout eww pipewire"

if [[ "$(uname -s)" == "Darwin" ]] && ! [ -n "${DOTFILES_SYNC_EXCLUDE+x}" ]; then
  DOTFILES_SYNC_EXCLUDE="$DEFAULT_MACOS_EXCLUDES"
fi

should_skip() {
  local base="$1" x
  [[ -z "${DOTFILES_SYNC_EXCLUDE:-}" ]] && return 1
  for x in $DOTFILES_SYNC_EXCLUDE; do
    [[ "$base" == "$x" ]] && return 0
  done
  return 1
}

if [[ ! -d "$SRC" ]]; then
  printf '%s\n' "sync-all-config: missing directory: $SRC" >&2
  exit 1
fi

if [[ "${DRY_RUN:-0}" == "1" ]]; then
  printf '[dry-run] would sync: %s -> %s\n' "$SRC" "$DEST"
fi

shopt -s nullglob
for item in "$SRC"/*; do
  [[ -e "$item" ]] || continue
  base=$(basename "$item")

  if should_skip "$base"; then
    if [[ "${DRY_RUN:-0}" == "1" ]]; then
      printf '  %s (skip)\n' "$base"
    else
      printf '[sync-all-config] skip %s (DOTFILES_SYNC_EXCLUDE)\n' "$base"
    fi
    continue
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    printf '  %s\n' "$base"
    continue
  fi

  if [[ -d "$item" ]]; then
    mkdir -p "$DEST/$base"
    cp -a "$item"/. "$DEST/$base"/
    printf '[sync-all-config] %s -> %s/%s\n' "$item" "$DEST" "$base"
  else
    cp -a "$item" "$DEST/$base"
    printf '[sync-all-config] %s -> %s/%s\n' "$item" "$DEST" "$base"
  fi
done
shopt -u nullglob

printf '[sync-all-config] done.\n'
