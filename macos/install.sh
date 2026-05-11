#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || {
  printf '%s\n' "macos/install.sh is for macOS only (MacPorts)." >&2
  exit 1
}

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORTLIST="$ROOT/macos/ports.txt"

sync_note="Hyprland / Wayland stack dirs skipped on macOS by default; set DOTFILES_SYNC_EXCLUDE='' for full config/"
echo "Dotfiles: config → ~/.config ($sync_note) …"
bash "$ROOT/scripts/dotfiles.sh" config

if [[ -d "$ROOT/home" ]]; then
  echo "Copying ${ROOT}/home/ -> $HOME …"
  cp -a "$ROOT/home"/. "$HOME"/
  for dot in "$HOME"/.zshrc "$HOME"/.tmux.conf; do
    [[ -f "$dot" ]] && chmod 600 "$dot"
  done
fi

if [[ -f "$ROOT/macos/.zshrc" ]]; then
  echo "Applying macOS zshrc (${ROOT}/macos/.zshrc -> $HOME/.zshrc) …"
  cp -a "$ROOT/macos/.zshrc" "$HOME/.zshrc"
  chmod 600 "$HOME/.zshrc"
fi

if ! command -v port >/dev/null 2>&1; then
  printf '%s\n' "MacPorts not found. Install from https://www.macports.org/install.php then re-run." >&2
  exit 1
fi

ports=()
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%$'\r'}"
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  stripped="$(echo "$line" | tr -d '[:space:]')"
  [[ -z "$stripped" ]] && continue
  ports+=("$line")
done <"$PORTLIST"

if [[ "${#ports[@]}" -eq 0 ]]; then
  printf '%s\n' "No ports listed in $PORTLIST" >&2
  exit 1
fi

if [[ "${SKIP_PORT_SELFUPDATE:-0}" != "1" ]]; then
  sudo port selfupdate
fi

echo "port install (${#ports[@]} ports) …"
sudo port -N install "${ports[@]}"

tpm="$HOME/.tmux/plugins/tpm"
if [[ ! -e "$tpm/tpm" ]]; then
  mkdir -p "$(dirname "$tpm")"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
fi
if [[ -x "$tpm/bin/install_plugins" ]]; then
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
  "$tpm/bin/install_plugins" || true
fi

printf '%s\n' \
  "Done. Optional: sudo port load syncthing (or run syncthing manually)." \
  "GUI apps / fonts that were Homebrew casks: see macos/GUI.md" \
  "uv has no MacPorts port — see macos/ports.txt header."
