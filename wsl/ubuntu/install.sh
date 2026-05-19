#!/usr/bin/env bash
set -euo pipefail

is_wsl() {
  [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null
}

if ! is_wsl && [[ "${WSL_UBUNTU_INSTALL_FORCE:-0}" != "1" ]]; then
  printf '%s\n' \
    "wsl/ubuntu/install.sh targets WSL Ubuntu." \
    "Set WSL_UBUNTU_INSTALL_FORCE=1 to run on plain Ubuntu." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PACKAGES="$ROOT/wsl/ubuntu/packages.txt"

ensure_apt() {
  command -v apt-get >/dev/null 2>&1 || {
    printf '%s\n' "apt-get not found; use Ubuntu/Debian." >&2
    exit 1
  }
}

read_packages() {
  local line stripped
  pkgs=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%$'\r'}"
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    stripped="$(echo "$line" | tr -d '[:space:]')"
    [[ -z "$stripped" ]] && continue
    pkgs+=("$stripped")
  done <"$PACKAGES"
}

link_ubuntu_cli_names() {
  mkdir -p "$HOME/.local/bin"
  if command -v fdfind >/dev/null 2>&1 && [[ ! -e "$HOME/.local/bin/fd" ]]; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
  if command -v batcat >/dev/null 2>&1 && [[ ! -e "$HOME/.local/bin/bat" ]]; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi
}

install_extras() {
  if ! command -v starship >/dev/null 2>&1; then
    echo "Installing starship …"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
  fi

  if ! command -v lazygit >/dev/null 2>&1; then
    echo "Installing lazygit …"
    _arch="$(uname -m)"
    case "$_arch" in
      x86_64) _lg_arch=Linux_x86_64 ;;
      aarch64|arm64) _lg_arch=Linux_arm64 ;;
      *)
        echo "Warning: lazygit skip (unsupported arch: $_arch)"
        _lg_arch=
        ;;
    esac
    if [[ -n "${_lg_arch:-}" ]]; then
      _lg_ver="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')"
      _lg_tmp="$(mktemp -d)"
      curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${_lg_ver}/lazygit_${_lg_ver}_${_lg_arch}.tar.gz" \
        | tar -xz -C "$_lg_tmp"
      install -m 755 "$_lg_tmp/lazygit" "$HOME/.local/bin/lazygit"
      rm -rf "$_lg_tmp"
    fi
    unset _arch _lg_arch _lg_ver _lg_tmp
  fi

  if ! command -v fastfetch >/dev/null 2>&1; then
    echo "Installing fastfetch …"
    _arch="$(uname -m)"
    case "$_arch" in
      x86_64) _ff_arch=amd64 ;;
      aarch64|arm64) _ff_arch=aarch64 ;;
      *)
        echo "Warning: fastfetch skip (unsupported arch: $_arch)"
        _ff_arch=
        ;;
    esac
    if [[ -n "${_ff_arch:-}" ]]; then
      _ff_ver="$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')"
      _ff_tmp="$(mktemp -d)"
      curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/${_ff_ver}/fastfetch-linux-${_ff_arch}.tar.gz" \
        | tar -xz -C "$_ff_tmp"
      install -m 755 "$_ff_tmp/fastfetch-linux-${_ff_arch}/usr/bin/fastfetch" "$HOME/.local/bin/fastfetch"
      rm -rf "$_ff_tmp"
    fi
    unset _arch _ff_arch _ff_ver _ff_tmp
  fi

  if ! command -v bun >/dev/null 2>&1; then
    echo "Installing bun …"
    curl -fsSL https://bun.sh/install | bash
  fi
}

install_tpm() {
  local tpm="$HOME/.tmux/plugins/tpm"
  if [[ ! -e "$tpm/tpm" ]]; then
    mkdir -p "$(dirname "$tpm")"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
  fi
  if [[ -x "$tpm/bin/install_plugins" ]]; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
    "$tpm/bin/install_plugins" || true
  fi
}

ensure_apt

read_packages
if [[ "${#pkgs[@]}" -eq 0 ]]; then
  printf '%s\n' "No packages listed in $PACKAGES" >&2
  exit 1
fi

echo "apt update …"
sudo apt-get update -qq

echo "Bootstrap: git + stow …"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git stow

sync_note="Hyprland / Wayland stack skipped on WSL; set DOTFILES_SYNC_EXCLUDE='' for full config/"
echo "Dotfiles: push ($sync_note) …"
DOTFILES_SYNC_EXCLUDE="${DOTFILES_SYNC_EXCLUDE:-hypr HyprPaper waybar swaync wlogout eww pipewire}"
export DOTFILES_SYNC_EXCLUDE
bash "$ROOT/scripts/dotfiles.sh" push

if [[ -f "$ROOT/wsl/ubuntu/.zshrc" ]]; then
  echo "Applying WSL zshrc (${ROOT}/wsl/ubuntu/.zshrc -> $HOME/.zshrc) …"
  cp -a "$ROOT/wsl/ubuntu/.zshrc" "$HOME/.zshrc"
  chmod 600 "$HOME/.zshrc"
fi

echo "apt install (${#pkgs[@]} packages) …"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${pkgs[@]}"

link_ubuntu_cli_names
install_extras
install_tpm

if command -v chsh >/dev/null 2>&1 && [[ "${SHELL:-}" != */zsh ]]; then
  printf '%s\n' "Optional: chsh -s \"$(command -v zsh)\" then reopen the terminal."
fi

printf '%s\n' \
  "Done." \
  "Extras: starship, lazygit, fastfetch, bun (when missing)." \
  "uv has no apt package — see wsl/ubuntu/packages.txt header." \
  "Syncthing: syncthing serve (or enable user systemd if available)."
