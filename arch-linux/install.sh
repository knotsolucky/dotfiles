#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Official packages to install via pacman
OFFICIAL_PKGS=(
  git base-devel stow hyprland hyprutils hyprwayland-scanner hypridle hyprlock hyprpicker
  hyprpaper xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland waybar swaync swaybg kitty alacritty
  ghostty rofi-wayland neovim tree-sitter tree-sitter-cli fd ripgrep syncthing fzf bat eza zoxide lazygit yazi btop htop
  fastfetch pipewire wireplumber pipewire-pulse polkit-kde-agent networkmanager ufw wireguard-tools
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
  elephant-all google-chrome helium-browser-bin wlogout walker-bin localsend-bin tidal-hifi nwg-look 1password cursor-bin
  obsidian-bin neofetch visual-studio-code-bin zen-browser-bin nerd-fonts-sf-mono pwrate
)

echo "Bootstrap: git + stow (needed for dotfiles home link) …"
sudo pacman -S --needed --noconfirm git stow

echo "Dotfiles: config + home + hyprsplit …"
bash "$ROOT/scripts/dotfiles.sh"

echo "Installing official packages using pacman …"
sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}"

# AUR helper: bootstrap from AUR if missing (needs base-devel + git from pacman step above)
AUR_HELPER_BIN="yay"

if ! command -v "$AUR_HELPER_BIN" &>/dev/null; then
  echo "Building and installing $AUR_HELPER_BIN from AUR …"
  _yay_tmp="$(mktemp -d)"
  git clone --depth 1 https://aur.archlinux.org/yay.git "$_yay_tmp/yay"
  (cd "$_yay_tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$_yay_tmp"
  unset _yay_tmp
fi

if command -v "$AUR_HELPER_BIN" &>/dev/null; then
  echo "Installing AUR packages using $AUR_HELPER_BIN …"
  "$AUR_HELPER_BIN" -S --needed --noconfirm "${AUR_PKGS[@]}"
else
  echo "Warning: $AUR_HELPER_BIN not available; skipping AUR packages."
fi

# --- HARDWARE & SYSTEM ---
echo "Enabling NetworkManager, Bluetooth, and Docker …"
sudo systemctl enable --now NetworkManager bluetooth docker.service

echo "Configuring UFW (SSH worldwide; dev servers + LocalSend LAN-only on RFC1918) …"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'ssh'
_DEV_NETS=(10.0.0.0/8 172.16.0.0/12 192.168.0.0/16)
_DEV_PORTS=(3000 3001 5173 8081 19000 19001)
# LocalSend: https://github.com/localsend/protocol — default 53317 TCP (HTTP API) + UDP (multicast discovery)
_LOCALSEND_PORT=53317
for net in "${_DEV_NETS[@]}"; do
  for port in "${_DEV_PORTS[@]}"; do
    sudo ufw allow from "$net" to any port "$port" proto tcp comment 'lan dev'
  done
  sudo ufw allow from "$net" to any port "$_LOCALSEND_PORT" proto tcp comment 'localsend'
  sudo ufw allow from "$net" to any port "$_LOCALSEND_PORT" proto udp comment 'localsend'
done
unset _DEV_NETS _DEV_PORTS _LOCALSEND_PORT
sudo ufw --force enable
sudo systemctl enable ufw.service

echo "Initializing MariaDB (skipped if data directory already exists) …"
if ! sudo test -d /var/lib/mysql/mysql 2>/dev/null; then
  sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi
sudo systemctl enable --now mariadb

echo "Enabling Syncthing (user service) …"
systemctl --user enable --now syncthing.service || echo "Warning: syncthing user enable failed (needs logind session; retry after graphical login)."

# --- WALKER & ELEPHANT ---
if command -v elephant &>/dev/null; then
  elephant service enable
  systemctl --user start elephant || echo "Warning: elephant user start failed (needs logind session or run after login)."
else
  echo "Warning: elephant not on PATH; install elephant-all (AUR) then run: elephant service enable && systemctl --user start elephant"
fi

echo "Installation complete."
