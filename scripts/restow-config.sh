#!/usr/bin/env bash
set -euo pipefail
r=$(cd "$(dirname "$0")/.." && pwd)
cd "$r"
command -v stow >/dev/null || exit 1
t=${XDG_CONFIG_HOME:-$HOME/.config}
for p in alacritty bat btop fastfetch ghostty htop hypr HyprPaper kitty lazygit neofetch nvim pipewire starship swaync waybar yazi; do
  [[ -d config/$p ]] || continue
  mkdir -p "$t/$p"
  stow -R -d config -t "$t/$p" "$p"
done
[[ -d home ]] && stow -R -t "$HOME" home
