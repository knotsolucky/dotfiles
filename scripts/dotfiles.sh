#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  printf '%s\n' \
    "usage: dotfiles.sh [push|config|pull] …" \
    "  push   config → ~/.config, stow home, hyprsplit (default)" \
    "  config ~/.config only" \
    "  pull   ~/.config → repo for names already under config/  (--delete --dry-run)"
}

sync_all_config() {
  local SRC="$ROOT/config"
  local DEST="${XDG_CONFIG_HOME:-$HOME/.config}"
  local DEFAULT_MACOS_EXCLUDES="hypr HyprPaper waybar swaync wlogout eww pipewire"

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
    printf '%s\n' "[dotfiles] missing $SRC" >&2
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
        printf '[dotfiles] skip %s\n' "$base"
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
    else
      cp -a "$item" "$DEST/$base"
    fi
    printf '[dotfiles] %s -> %s\n' "$base" "$DEST/$base"
  done
  shopt -u nullglob

  printf '[dotfiles] config done.\n'
}

ensure_hyprsplit() {
  command -v hyprpm >/dev/null 2>&1 || return 0
  hyprpm update || true
  yes | hyprpm add https://github.com/shezdy/hyprsplit || true
  hyprpm enable hyprsplit || true
  hyprpm reload -n || true
}

sync_home() {
  if [[ ! -d "$ROOT/home" ]]; then
    printf '[dotfiles] skip home (no %s/home)\n' "$ROOT"
    return 0
  fi
  if ! command -v stow >/dev/null 2>&1; then
    printf '%s\n' "[dotfiles] install stow" >&2
    exit 1
  fi

  local src base target bak
  while IFS= read -r -d '' src; do
    base=$(basename "$src")
    target="$HOME/$base"
    if [[ -f "$target" && ! -L "$target" ]]; then
      bak="${target}.sync-home.bak.$(date +%Y%m%d%H%M%S)"
      mv "$target" "$bak"
      printf '[dotfiles] backed up %s -> %s\n' "$target" "$bak"
    fi
  done < <(find "$ROOT/home" -mindepth 1 -maxdepth 1 -type f -print0 2>/dev/null || true)

  (cd "$ROOT" && stow -R -t "$HOME" home)
  printf '[dotfiles] home stowed -> %s\n' "$HOME"
}

cmd_pull() {
  local SRC="${XDG_CONFIG_HOME:-$HOME/.config}"
  local DEST="$ROOT/config"
  local DRY_RUN=0 DELETE_STALE=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --delete) DELETE_STALE=1 ;;
      --dry-run) DRY_RUN=1 ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        printf 'unknown: %s\n' "$1" >&2
        usage >&2
        exit 1
        ;;
    esac
    shift
  done

  if [[ ! -d "$SRC" ]]; then
    printf '[dotfiles] missing %s\n' "$SRC" >&2
    exit 1
  fi

  mkdir -p "$DEST"

  local -a targets=()
  local item
  shopt -s nullglob dotglob
  for item in "$DEST"/*; do
    [[ -e "$item" ]] || continue
    targets+=("$(basename "$item")")
  done
  shopt -u nullglob dotglob

  if [[ "${#targets[@]}" -eq 0 ]]; then
    printf '[dotfiles] pull: nothing under repo config/\n'
    exit 0
  fi

  local HAS_RSYNC=0
  command -v rsync >/dev/null 2>&1 && HAS_RSYNC=1

  local -a rsync_flags=(-a)
  [[ "$DELETE_STALE" -eq 1 ]] && rsync_flags+=(--delete)
  [[ "$DRY_RUN" -eq 1 ]] && rsync_flags+=(--dry-run --itemize-changes)

  local base src_path dest_path
  for base in "${targets[@]}"; do
    src_path="$SRC/$base"
    dest_path="$DEST/$base"

    if [[ ! -e "$src_path" ]]; then
      printf '[dotfiles] pull skip (no %s)\n' "$src_path"
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
      printf '[dotfiles] pull %s\n' "$base"
      continue
    fi

    if [[ "$DRY_RUN" -eq 1 ]]; then
      printf '[dotfiles] pull dry-run (install rsync): %s\n' "$base"
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
    printf '[dotfiles] pull %s\n' "$base"
  done

  printf '[dotfiles] pull done.\n'
}

case "${1:-push}" in
  push)
    sync_all_config
    sync_home
    ensure_hyprsplit
    ;;
  config)
    sync_all_config
    ;;
  pull)
    shift
    cmd_pull "$@"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    printf 'unknown: %s\n' "$1" >&2
    usage >&2
    exit 1
    ;;
esac
