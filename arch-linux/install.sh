#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
cd "$here"

OFFICIAL_PKGS=(
  git base-devel stow hyprland hyprutils hyprwayland-scanner hypridle hyprlock hyprpicker
  xdg-desktop-portal-hyprland qt5-wayland qt6-wayland waybar swaync swaybg kitty alacritty
  ghostty rofi-wayland neovim fd ripgrep syncthing fzf bat eza zoxide lazygit yazi btop htop
  fastfetch pipewire wireplumber pipewire-pulse polkit-kde-agent networkmanager wireguard-tools
  openvpn networkmanager-openvpn nm-connection-editor bluez bluez-utils brightnessctl pamixer
  grim slurp wf-recorder zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
  ttf-jetbrains-mono pacman-contrib cmake docker docker-compose dotnet-sdk ffmpeg firefox gcc
  github-cli go jdk-openjdk llvm lua make maven mariadb dotnet-runtime nodejs npm putty python
  python-pip uv raylib rust sdl2 starship tmux tree unzip zip ttf-fira-code otf-geist-mono-nerd
  otf-comicshanns-nerd ttf-firacode-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd
)

AUR_PKGS=(
  elephant-all wlogout walker-bin localsend-bin tidal-hifi nwg-look 1password cursor-bin
  obsidian-bin neofetch visual-studio-code-bin
)

sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}"

h="${AUR_HELPER:-yay}"
command -v "$h" >/dev/null 2>&1 || h=paru
command -v "$h" >/dev/null 2>&1 || { echo "need yay or paru" >&2; exit 1; }
((${#AUR_PKGS[@]})) && "$h" -S --needed --noconfirm "${AUR_PKGS[@]}"

repo=$(cd "$here/.." && pwd)
dest=${XDG_CONFIG_HOME:-$HOME/.config}
shopt -s nullglob
for d in "$repo/config"/*/; do
  n=$(basename "$d")
  mkdir -p "$dest/$n"
  cp -a "$d"/. "$dest/$n"/
done
shopt -u nullglob

if [[ -d "$repo/home" ]]; then
  cp -a "$repo/home"/. "$HOME"/
fi

for s in pipewire wireplumber pipewire-pulse syncthing hypridle plasma-polkit-agent \
  xdg-desktop-portal-hyprland; do
  systemctl --user enable --now "${s}.service" 2>/dev/null || true
done

for s in NetworkManager NetworkManager-dispatcher NetworkManager-wait-online bluetooth docker mariadb; do
  sudo systemctl enable --now "${s}.service" 2>/dev/null || true
done
