#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"

log() {
  printf '[install] %s\n' "$*"
}

warn() {
  printf '[install][warn] %s\n' "$*" >&2
}

OFFICIAL_PKGS=(
  git base-devel stow hyprland hyprutils hyprwayland-scanner hypridle hyprlock hyprpicker
  hyprpaper xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland waybar swaync swaybg kitty alacritty
  ghostty rofi-wayland neovim tree-sitter tree-sitter-cli fd ripgrep syncthing fzf bat eza zoxide lazygit yazi btop htop
  fastfetch pipewire wireplumber pipewire-pulse polkit-kde-agent networkmanager wireguard-tools
  openvpn networkmanager-openvpn nm-connection-editor bluez bluez-utils brightnessctl pamixer pavucontrol
  grim slurp hyprshot wf-recorder gnome-system-monitor gnome-calendar gnome-control-center
  zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
  ttf-jetbrains-mono pacman-contrib cmake croc docker docker-compose dotnet-sdk ffmpeg firefox vivaldi gcc
  github-cli go jdk-openjdk llvm lua make maven mariadb dotnet-runtime npm bun putty python
  python-pip uv raylib rust sdl2 starship tmux tree unzip zip ttf-fira-code otf-geist-mono-nerd
  otf-comicshanns-nerd ttf-firacode-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd
)
# nodejs (current) conflicts with nodejs-lts-*; npm only needs a provider of nodejs (e.g. nodejs-lts-jod).
if ! pacman -Qqo /usr/bin/node &>/dev/null; then
  OFFICIAL_PKGS+=(nodejs)
fi

AUR_PKGS=(
  elephant-all google-chrome wlogout walker-bin localsend-bin tidal-hifi nwg-look 1password cursor-bin
  obsidian-bin neofetch visual-studio-code-bin zen-browser-bin nerd-fonts-sf-mono
)

PACMAN_INSTALLABLE=()
PACMAN_MISSING=()
for pkg in "${OFFICIAL_PKGS[@]}"; do
  if pacman -Si "$pkg" &>/dev/null; then
    PACMAN_INSTALLABLE+=("$pkg")
  else
    PACMAN_MISSING+=("$pkg")
  fi
done

if ((${#PACMAN_MISSING[@]} > 0)); then
  warn "Skipping unavailable pacman packages: ${PACMAN_MISSING[*]}"
fi

if ((${#PACMAN_INSTALLABLE[@]} > 0)); then
  log "Installing official packages via pacman..."
  sudo pacman -S --needed --noconfirm "${PACMAN_INSTALLABLE[@]}"
else
  warn "No installable pacman packages resolved."
fi

AUR_HELPER_BIN="${AUR_HELPER:-yay}"
if ! command -v "$AUR_HELPER_BIN" &>/dev/null; then
  warn "AUR helper '$AUR_HELPER_BIN' not found; skipping AUR packages."
else
  EWW_AUR_CANDIDATES=(eww-wayland-git eww-git eww-wayland eww)
  EWW_SELECTED=""
  for pkg in "${EWW_AUR_CANDIDATES[@]}"; do
    if "$AUR_HELPER_BIN" -Si "$pkg" &>/dev/null; then
      EWW_SELECTED="$pkg"
      break
    fi
  done

  if [[ -n "$EWW_SELECTED" ]]; then
    AUR_PKGS+=("$EWW_SELECTED")
  else
    warn "No Eww package found in AUR candidate set: ${EWW_AUR_CANDIDATES[*]}"
  fi

  if ((${#AUR_PKGS[@]} > 0)); then
    log "Installing AUR packages via $AUR_HELPER_BIN..."
    if ! "$AUR_HELPER_BIN" -S --needed --noconfirm "${AUR_PKGS[@]}"; then
      warn "AUR install reported errors; continuing remaining setup."
    fi
  else
    warn "No AUR packages queued for installation."
  fi
fi

log "Syncing entire repo config/ -> $CFG (see scripts/sync-all-config.sh)..."
mkdir -p "$CFG"
bash "$ROOT/scripts/sync-all-config.sh"

if [[ -d "$ROOT/home" ]]; then
  cp -a "$ROOT/home"/. "$HOME"/
  log "Synced home dotfiles into $HOME"
  for dot in "$HOME"/.zshrc "$HOME"/.tmux.conf; do
    [[ -f "$dot" ]] && chmod 600 "$dot"
  done
fi

tpm="$HOME/.tmux/plugins/tpm"
if [[ ! -e "$tpm/tpm" ]]; then
  mkdir -p "$(dirname "$tpm")"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
  log "Cloned tmux TPM plugin manager."
fi
if [[ -x "$tpm/bin/install_plugins" ]]; then
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
  "$tpm/bin/install_plugins" || true
  log "Attempted tmux plugin installation."
fi

for s in pipewire wireplumber pipewire-pulse syncthing hypridle plasma-polkit-agent xdg-desktop-portal-hyprland eww; do
  if systemctl --user enable --now "${s}.service" &>/dev/null; then
    log "Enabled user service: ${s}.service"
  else
    warn "Could not enable user service: ${s}.service"
  fi
done
for s in NetworkManager NetworkManager-dispatcher NetworkManager-wait-online bluetooth docker mariadb; do
  unit="${s}.service"
  if ! systemctl cat "$unit" &>/dev/null; then
    continue
  fi
  if sudo systemctl enable --now "$unit" &>/dev/null; then
    log "Enabled system service: $unit"
  else
    warn "Could not enable system service: $unit"
  fi
done

log "Install script finished."
