#!/usr/bin/env bash
# macOS: Homebrew bundle + full repo config/ → ~/.config (no Linux desktop stack or systemd).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$ROOT/macos/Brewfile"

if ! command -v brew >/dev/null 2>&1; then
  printf '%s\n' "Homebrew not found. Install from https://brew.sh then re-run:" >&2
  printf '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n' >&2
  exit 1
fi

echo "brew bundle --file=$BREWFILE"
brew bundle install --file="$BREWFILE"

echo "Syncing ${ROOT}/config/ -> ${XDG_CONFIG_HOME:-$HOME/.config} (Hyprland / Wayland stack dirs skipped on macOS; set DOTFILES_SYNC_EXCLUDE='' to sync everything) ..."
bash "$ROOT/scripts/sync-all-config.sh"

if [[ -d "$ROOT/home" ]]; then
  echo "Copying ${ROOT}/home/ -> $HOME ..."
  cp -a "$ROOT/home"/. "$HOME"/
  for dot in "$HOME"/.zshrc "$HOME"/.tmux.conf; do
    [[ -f "$dot" ]] && chmod 600 "$dot"
  done
fi

tpm="$HOME/.tmux/plugins/tpm"
if [[ ! -e "$tpm/tpm" ]]; then
  mkdir -p "$(dirname "$tpm")"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
fi
if [[ -x "$tpm/bin/install_plugins" ]]; then
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
  "$tpm/bin/install_plugins" || true
fi

echo "Optional: brew services start syncthing  (or use Syncthing from Docker / app)."
echo "Installation complete."
