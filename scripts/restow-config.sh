#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONFIG_ROOT="${DOTFILES_ROOT}/config"
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
  tmux
  waybar
  yazi
)

cd "${DOTFILES_ROOT}"

# Packages live under config/<pkg>/; stow -t ~/.config/<pkg> maps to ~/.config/hypr/hyprland.conf etc.
for pkg in "${PACKAGES[@]}"; do
  if [[ ! -d "${CONFIG_ROOT}/${pkg}" ]]; then
    echo "skip (no package dir): ${pkg}" >&2
    continue
  fi
  mkdir -p "${TARGET}/${pkg}"
  stow -v -R -d "${CONFIG_ROOT}" -t "${TARGET}/${pkg}" "${pkg}"
done

if [[ -d "${DOTFILES_ROOT}/home" ]]; then
  stow -v -R -t "${HOME}" home
fi
