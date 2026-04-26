#!/usr/bin/env bash
set -euo pipefail
r=$(cd "$(dirname "$0")/.." && pwd)
cd "$r"
# config/ → ~/.config (scripts/sync-all-config.sh), hyprsplit via hyprpm, repo home/ → $HOME (scripts/sync-home.sh)
bash "$r/scripts/sync-all-config.sh"
bash "$r/scripts/ensure-hyprsplit.sh"
bash "$r/scripts/sync-home.sh"
