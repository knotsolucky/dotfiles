#!/usr/bin/env bash
# Sync everything under repo config/ into $XDG_CONFIG_HOME (~/.config by default).
# Each immediate child of config/ becomes ~/.config/<name>/ (directories merged; files copied as-is).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/config"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}"

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
