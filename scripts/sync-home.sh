#!/usr/bin/env bash
# Symlink repo home/ into $HOME via GNU stow (same layout as restow-config).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ ! -d "$ROOT/home" ]]; then
  printf '[sync-home] skip: no directory %s/home\n' "$ROOT"
  exit 0
fi

if ! command -v stow >/dev/null 2>&1; then
  printf '%s\n' "sync-home: install stow (e.g. pacman -S stow)" >&2
  exit 1
fi

cd "$ROOT"
stow -R -t "$HOME" home
printf '[sync-home] stow package home -> %s\n' "$HOME"
