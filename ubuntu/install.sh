#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
export DEBIAN_FRONTEND=noninteractive
# Avoid needrestart blocking unattended installs on servers (apt hook).
export NEEDRESTART_MODE=a

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script expects apt (Debian/Ubuntu)." >&2
  exit 1
fi

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl software-properties-common
sudo add-apt-repository -y universe 2>/dev/null || true
sudo apt-get update -y

append_if_pkg() {
  local p
  for p in "$@"; do
    if apt-cache show "$p" &>/dev/null; then
      APT_PKGS+=("$p")
    fi
  done
}

APT_PKGS=(
  git stow build-essential pkg-config cmake
  neovim fd-find ripgrep syncthing fzf zoxide tmux unzip zip wget
  htop
  openvpn
  wireguard-tools
  zsh
  golang-go default-jdk-headless maven rustc cargo llvm clang make
  lua5.4 python3 python3-pip python3-venv
  gcc g++ ffmpeg
)

# Ubuntu Server often uses netplan + systemd-networkd; NM is optional.
if [[ "${DOTFILES_UBUNTU_SKIP_NETWORKMANAGER:-0}" != "1" ]]; then
  APT_PKGS+=(network-manager network-manager-openvpn)
else
  echo "Skipping NetworkManager (DOTFILES_UBUNTU_SKIP_NETWORKMANAGER=1)."
fi

if apt-cache show tree-sitter-cli &>/dev/null; then
  APT_PKGS+=(tree-sitter-cli)
elif apt-cache show tree-sitter &>/dev/null; then
  APT_PKGS+=(tree-sitter)
fi
append_if_pkg bat eza btop
append_if_pkg zsh-autosuggestions zsh-syntax-highlighting
append_if_pkg gh
append_if_pkg lazygit
append_if_pkg yazi
append_if_pkg starship
append_if_pkg fastfetch
append_if_pkg ninja-build meson
append_if_pkg dotnet-sdk-8.0 dotnet-runtime-8.0
append_if_pkg putty
if [[ "${DOTFILES_UBUNTU_SKIP_MARIADB:-0}" != "1" ]]; then
  append_if_pkg mariadb-server mariadb-client
else
  echo "Skipping MariaDB (DOTFILES_UBUNTU_SKIP_MARIADB=1)."
fi

# Docker stack:
# - Prefer Docker CE packages when Docker upstream repo is configured.
# - Fall back to Ubuntu docker.io packages otherwise.
if apt-cache show docker-ce &>/dev/null && apt-cache show containerd.io &>/dev/null; then
  append_if_pkg docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  append_if_pkg docker.io docker-compose-v2 docker-compose-plugin docker-compose
fi

if ! command -v node >/dev/null 2>&1; then
  append_if_pkg nodejs npm
fi

APT_EXTRA_OPTS=()
if [[ "${DOTFILES_UBUNTU_APT_MINIMAL:-0}" == "1" ]]; then
  APT_EXTRA_OPTS+=(--no-install-recommends)
  echo "Using apt --no-install-recommends (DOTFILES_UBUNTU_APT_MINIMAL=1)."
fi

sudo apt-get install -y "${APT_EXTRA_OPTS[@]}" "${APT_PKGS[@]}"

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  sudo update-alternatives --install /usr/local/bin/fd fd "$(command -v fdfind)" 30 2>/dev/null || true
fi
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  sudo update-alternatives --install /usr/local/bin/bat bat "$(command -v batcat)" 30 2>/dev/null || true
fi

if getent group docker >/dev/null 2>&1 && ! id -nG "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  echo "Added $USER to group docker (log out and back in for it to apply)."
fi

echo "Syncing all of $ROOT/config/ -> $CFG ..."
bash "$ROOT/scripts/sync-all-config.sh"

if [[ -d "$ROOT/home" ]]; then
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

if [[ "${DOTFILES_UBUNTU_SYNCTHING_SYSTEM:-0}" == "1" ]]; then
  sudo systemctl enable --now "syncthing@${USER}.service" 2>/dev/null || true
else
  systemctl --user enable --now syncthing.service 2>/dev/null || true
fi

for s in NetworkManager NetworkManager-dispatcher NetworkManager-wait-online docker mariadb; do
  if [[ "${DOTFILES_UBUNTU_SKIP_NETWORKMANAGER:-0}" == "1" ]] && [[ "$s" == NetworkManager* ]]; then
    continue
  fi
  if [[ "${DOTFILES_UBUNTU_SKIP_MARIADB:-0}" == "1" ]] && [[ "$s" == mariadb ]]; then
    continue
  fi
  sudo systemctl enable --now "${s}.service" 2>/dev/null || true
done
