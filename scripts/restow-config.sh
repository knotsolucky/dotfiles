#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET="${XDG_CONFIG_HOME:-${HOME}/.config}"

if ! command -v stow >/dev/null 2>&1; then
  echo "stow not found. On Arch: sudo pacman -S stow" >&2
  exit 1
fi

PACKAGES=(
  alacritty
  btop
  fastfetch
  ghostty
  htop
  hypr
  HyprPaper
  kitty
  nvim
  pipewire
  swaync
  waybar
  yazi
)

cd "${DOTFILES_ROOT}"

# One target per package: stow -t ~/.config puts files in ~/.config/, not ~/.config/<pkg>/.
# Use -t "${TARGET}/<pkg>" so repo layout hypr/hyprland.conf becomes ~/.config/hypr/hyprland.conf.
for pkg in "${PACKAGES[@]}"; do
  if [[ ! -d "${DOTFILES_ROOT}/${pkg}" ]]; then
    echo "skip (no package dir): ${pkg}" >&2
    continue
  fi
  mkdir -p "${TARGET}/${pkg}"
  stow -v -R -t "${TARGET}/${pkg}" "${pkg}"
done
