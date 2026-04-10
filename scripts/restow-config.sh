#!/usr/bin/env bash
set -euo pipefail
r=$(cd "$(dirname "$0")/.." && pwd)
cd "$r"
# All of config/ → ~/.config (no per-app stow list; see scripts/sync-all-config.sh)
bash "$r/scripts/sync-all-config.sh"
if [[ -d home ]]; then
  command -v stow >/dev/null || { printf '%s\n' "restow-config: install stow for ~/home dotfiles" >&2; exit 1; }
  stow -R -t "$HOME" home
fi
