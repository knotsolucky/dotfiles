#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"

OFFICIAL_PKGS=(
  git base-devel stow hyprland hyprutils hyprwayland-scanner hypridle hyprlock hyprpicker
  xdg-desktop-portal-hyprland qt5-wayland qt6-wayland waybar swaync swaybg kitty alacritty
  ghostty rofi-wayland neovim fd ripgrep syncthing fzf bat eza zoxide lazygit yazi btop htop
  fastfetch pipewire wireplumber pipewire-pulse polkit-kde-agent networkmanager wireguard-tools
  openvpn networkmanager-openvpn nm-connection-editor bluez bluez-utils brightnessctl pamixer
  grim slurp wf-recorder zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
  ttf-jetbrains-mono pacman-contrib cmake croc docker docker-compose dotnet-sdk ffmpeg firefox vivaldi gcc
  github-cli go jdk-openjdk llvm lua make maven mariadb dotnet-runtime nodejs npm putty python
  python-pip uv raylib rust sdl2 starship tmux tree unzip zip ttf-fira-code otf-geist-mono-nerd
  otf-comicshanns-nerd ttf-firacode-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd
)
AUR_PKGS=(
  elephant-all google-chrome wlogout walker-bin localsend-bin tidal-hifi nwg-look 1password cursor-bin
  obsidian-bin neofetch visual-studio-code-bin zen-browser-bin
)

sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}"
${AUR_HELPER:-yay} -S --needed --noconfirm "${AUR_PKGS[@]}"

mkdir -p "$CFG"
shopt -s nullglob
for dir in "$ROOT/config"/*; do
  [[ -d "$dir" ]] || continue
  name=$(basename "$dir")
  mkdir -p "$CFG/$name"
  cp -a "$dir"/. "$CFG/$name/"
done
shopt -u nullglob

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

for s in pipewire wireplumber pipewire-pulse syncthing hypridle plasma-polkit-agent xdg-desktop-portal-hyprland; do
  systemctl --user enable --now "${s}.service" 2>/dev/null || true
done
for s in NetworkManager NetworkManager-dispatcher NetworkManager-wait-online bluetooth docker mariadb; do
  sudo systemctl enable --now "${s}.service" 2>/dev/null || true
done
