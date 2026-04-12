#!/usr/bin/env bash
# Homebrew bundle (macOS or Linuxbrew) + config sync. Casks run only on macOS.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="${DOTFILES_BREWFILE:-$ROOT/macos/Brewfile}"

if ! command -v brew >/dev/null 2>&1; then
  printf '%s\n' "Homebrew not found. Install from https://brew.sh then re-run:" >&2
  printf '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n' >&2
  exit 1
fi

os="$(uname -s)"
bundle_file="$BREWFILE"
tmp_brewfile=""
if [[ "$os" != "Darwin" ]]; then
  tmp_brewfile="$(mktemp "${TMPDIR:-/tmp}/dotfiles-brewfile.XXXXXX")"
  grep -Ev '^[[:space:]]*cask([[:space:]]|\()' "$BREWFILE" >"$tmp_brewfile"
  bundle_file="$tmp_brewfile"
fi

echo "brew bundle install --file=$bundle_file"
brew bundle install --file="$bundle_file"
[[ -n "$tmp_brewfile" ]] && rm -f "$tmp_brewfile"

sync_note="full config/"
if [[ "$os" == "Darwin" ]]; then
  sync_note="Hyprland / Wayland stack dirs skipped on macOS by default; set DOTFILES_SYNC_EXCLUDE='' for full config/"
fi
echo "Syncing ${ROOT}/config/ -> ${XDG_CONFIG_HOME:-$HOME/.config} ($sync_note) ..."
bash "$ROOT/scripts/sync-all-config.sh"

if [[ -d "$ROOT/home" ]]; then
  echo "Copying ${ROOT}/home/ -> $HOME ..."
  cp -a "$ROOT/home"/. "$HOME"/
  for dot in "$HOME"/.zshrc "$HOME"/.tmux.conf; do
    [[ -f "$dot" ]] && chmod 600 "$dot"
  done
fi

if [[ -f "$ROOT/macos/.zshrc" ]]; then
  echo "Applying Homebrew-oriented zsh (${ROOT}/macos/.zshrc -> $HOME/.zshrc) ..."
  cp -a "$ROOT/macos/.zshrc" "$HOME/.zshrc"
  chmod 600 "$HOME/.zshrc"
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
