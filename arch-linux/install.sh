#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${DIR}/.." && pwd)"

usage() {
  echo "Usage: $0 [--official-only | --aur-only] [--confirm]" >&2
  echo "  Default: non-interactive (pacman/yay --noconfirm), then AUR via yay if present." >&2
  echo "  --confirm  prompt before installs (no --noconfirm)" >&2
  exit 1
}

read_packages() {
  local file=$1
  grep -v '^#' "${file}" | sed '/^[[:space:]]*$/d' || true
}

OFFICIAL_ONLY=0
AUR_ONLY=0
NOCONFIRM=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --official-only) OFFICIAL_ONLY=1 ;;
    --aur-only) AUR_ONLY=1 ;;
    --confirm) NOCONFIRM=0 ;;
    --yes) ;; # deprecated; default is already non-interactive
    -h | --help) usage ;;
    *) usage ;;
  esac
  shift
done

mapfile -t OFFICIAL_PKGS < <(read_packages "${DIR}/packages.official")
mapfile -t AUR_PKGS < <(read_packages "${DIR}/packages.aur")

install_official() {
  if [[ ${#OFFICIAL_PKGS[@]} -eq 0 ]]; then
    echo "No packages in packages.official"
    return 0
  fi
  echo "Installing ${#OFFICIAL_PKGS[@]} official packages (pacman)..."
  if [[ "${NOCONFIRM}" -eq 1 ]]; then
    sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}"
  else
    sudo pacman -S --needed "${OFFICIAL_PKGS[@]}"
  fi
}

install_aur() {
  if [[ ${#AUR_PKGS[@]} -eq 0 ]]; then
    echo "No packages in packages.aur"
    return 0
  fi
  if ! command -v yay >/dev/null 2>&1; then
    echo "yay not found. Install from AUR, then re-run: $0 --aur-only" >&2
    echo "See: https://github.com/Jguer/yay" >&2
    return 1
  fi
  echo "Installing ${#AUR_PKGS[@]} AUR packages (yay)..."
  if [[ "${NOCONFIRM}" -eq 1 ]]; then
    yay -S --needed --noconfirm "${AUR_PKGS[@]}"
  else
    yay -S --needed "${AUR_PKGS[@]}"
  fi
}

if [[ "${AUR_ONLY}" -eq 1 ]]; then
  install_aur
  exit 0
fi

install_official

if [[ "${OFFICIAL_ONLY}" -eq 1 ]]; then
  exit 0
fi

if command -v yay >/dev/null 2>&1; then
  install_aur || true
else
  echo ""
  echo "Skip AUR: yay not installed. After installing yay, run:"
  echo "  ${DIR}/install.sh --aur-only"
fi

echo ""
echo "Deploy configs from this repo (symlinks via Stow):"
echo "  ${ROOT}/scripts/restow-config.sh"
echo "Docs: ${ROOT}/documentation/dotfiles-workflow.md"
