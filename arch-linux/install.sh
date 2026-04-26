#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Official packages to install via pacman
OFFICIAL_PKGS=(
  git base-devel stow hyprland hyprutils hyprwayland-scanner hypridle hyprlock hyprpicker
  hyprpaper xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland waybar swaync swaybg kitty alacritty
  ghostty rofi-wayland neovim tree-sitter tree-sitter-cli fd ripgrep syncthing fzf bat eza zoxide lazygit yazi btop htop
  fastfetch pipewire wireplumber pipewire-pulse polkit-kde-agent networkmanager wireguard-tools
  openvpn networkmanager-openvpn nm-connection-editor bluez bluez-utils brightnessctl pamixer pavucontrol
  grim slurp hyprshot wf-recorder
  zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
  ttf-jetbrains-mono pacman-contrib cmake croc docker docker-compose dotnet-sdk ffmpeg firefox vivaldi gcc
  github-cli go jdk-openjdk llvm lua make maven mariadb dotnet-runtime npm bun putty python
  python-pip uv raylib rust sdl2 starship tmux tree unzip zip ttf-fira-code otf-geist-mono-nerd
  otf-comicshanns-nerd ttf-firacode-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd
)

# AUR packages to install
AUR_PKGS=(
  elephant-all google-chrome wlogout walker-bin localsend-bin tidal-hifi nwg-look 1password cursor-bin
  obsidian-bin neofetch visual-studio-code-bin zen-browser-bin nerd-fonts-sf-mono pwrate
)

# Install official packages via pacman
echo "Installing official packages using pacman..."
sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}"

# Install AUR packages via yay (or any other AUR helper)
AUR_HELPER_BIN="yay"

if ! command -v "$AUR_HELPER_BIN" &>/dev/null; then
  echo "Warning: AUR helper '$AUR_HELPER_BIN' not found. Please install yay or another AUR helper."
else
  echo "Installing AUR packages using $AUR_HELPER_BIN..."
  "$AUR_HELPER_BIN" -S --needed --noconfirm "${AUR_PKGS[@]}"
fi

echo "Syncing all of ${ROOT}/config/ -> ${XDG_CONFIG_HOME:-$HOME/.config} ..."
bash "$ROOT/scripts/sync-all-config.sh"

# hyprsplit: per-monitor workspaces (hyprland.conf uses split:*). Ships with Hyprland as hyprpm.
echo "Installing / enabling hyprsplit via hyprpm (see documentation/hyprsplit.md) ..."
if command -v hyprpm >/dev/null 2>&1; then
  hyprpm update || echo "Warning: hyprpm update failed (network or headers); fix then run: yes | hyprpm add https://github.com/shezdy/hyprsplit && hyprpm enable hyprsplit"
  yes | hyprpm add https://github.com/shezdy/hyprsplit || echo "Warning: hyprpm add hyprsplit failed (already added, or build error — see stderr above)."
  hyprpm enable hyprsplit || echo "Warning: hyprpm enable hyprsplit failed."
  hyprpm reload -n || true
else
  echo "Warning: hyprpm not on PATH; hyprsplit not installed. Install hyprland, then follow documentation/hyprsplit.md"
fi

echo "Linking ${ROOT}/home/ -> $HOME (stow) ..."
bash "$ROOT/scripts/sync-home.sh"

# --- HARDWARE & SYSTEM ---
echo "Enabling NetworkManager, Bluetooth, and Docker..."
sudo systemctl enable --now NetworkManager bluetooth docker.service

echo "Initializing MariaDB (skipped if data directory already exists)..."
if ! sudo test -d /var/lib/mysql/mysql 2>/dev/null; then
  sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi
sudo systemctl enable --now mariadb

echo "Enabling Syncthing (user service)..."
systemctl --user enable --now syncthing.service || echo "Warning: syncthing user enable failed (needs logind session; retry after graphical login)."

# --- WALKER & ELEPHANT ---
if command -v elephant &>/dev/null; then
  elephant service enable
  systemctl --user start elephant || echo "Warning: elephant user start failed (needs logind session or run after login)."
else
  echo "Warning: elephant not on PATH; install elephant-all (AUR) then run: elephant service enable && systemctl --user start elephant"
fi

echo "Installation complete."

