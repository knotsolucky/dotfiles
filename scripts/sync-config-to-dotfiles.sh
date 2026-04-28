#!/usr/bin/env bash
# Sync local ~/.config back into repo config/ for commit.
# Sync only entries already tracked in repo config/.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${XDG_CONFIG_HOME:-$HOME/.config}"
DEST="$ROOT/config"

DRY_RUN=0
DELETE_STALE=0

usage() {
  cat <<'EOF'
Usage: sync-config-to-dotfiles.sh [--delete] [--dry-run]

Options:
  --delete   Delete files in destination that are missing from source
  --dry-run  Print planned changes only
  -h, --help Show this help text

Behavior:
  Sync only entries already present under repo config/.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --delete) DELETE_STALE=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ ! -d "$SRC" ]]; then
  printf 'sync-config-to-dotfiles: missing source directory: %s\n' "$SRC" >&2
  exit 1
fi

mkdir -p "$DEST"

declare -a targets=()
shopt -s nullglob dotglob
for item in "$DEST"/*; do
  [[ -e "$item" ]] || continue
  targets+=("$(basename "$item")")
done
shopt -u nullglob dotglob

if [[ "${#targets[@]}" -eq 0 ]]; then
  printf '[sync-config-to-dotfiles] nothing to sync.\n'
  exit 0
fi

HAS_RSYNC=0
if command -v rsync >/dev/null 2>&1; then
  HAS_RSYNC=1
fi

rsync_flags=(-a)
if [[ "$DELETE_STALE" -eq 1 ]]; then
  rsync_flags+=(--delete)
fi
if [[ "$DRY_RUN" -eq 1 ]]; then
  rsync_flags+=(--dry-run --itemize-changes)
fi

for base in "${targets[@]}"; do
  src_path="$SRC/$base"
  dest_path="$DEST/$base"

  if [[ ! -e "$src_path" ]]; then
    printf '[sync-config-to-dotfiles] skip missing source: %s\n' "$src_path"
    continue
  fi

  if [[ "$HAS_RSYNC" -eq 1 ]]; then
    if [[ -d "$src_path" ]]; then
      mkdir -p "$dest_path"
      rsync "${rsync_flags[@]}" "$src_path"/ "$dest_path"/
    else
      mkdir -p "$(dirname "$dest_path")"
      rsync "${rsync_flags[@]}" "$src_path" "$dest_path"
    fi
    printf '[sync-config-to-dotfiles] synced %s -> %s\n' "$src_path" "$dest_path"
    continue
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[sync-config-to-dotfiles] dry-run (no rsync): would sync %s -> %s\n' "$src_path" "$dest_path"
    continue
  fi

  if [[ "$DELETE_STALE" -eq 1 ]]; then
    rm -rf "$dest_path"
  fi

  if [[ -d "$src_path" ]]; then
    mkdir -p "$dest_path"
    cp -a "$src_path"/. "$dest_path"/
  else
    mkdir -p "$(dirname "$dest_path")"
    cp -a "$src_path" "$dest_path"
  fi
  printf '[sync-config-to-dotfiles] synced %s -> %s\n' "$src_path" "$dest_path"
done

printf '[sync-config-to-dotfiles] done.\n'
