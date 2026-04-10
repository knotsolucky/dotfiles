# Arch Linux setup (this dotfiles repo)

Use this folder to install **packages** that match the apps configured in `~/dotfiles`. Dotfiles for `~/.config` live under **[`../config/`](../config/)**; **`install.sh` copies** each subfolder there into `~/.config/` after package installs. Files under **[`../home/`](../home/)** (e.g. **`.zshrc`**) are copied into **`$HOME`**. Use **`chsh -s /bin/zsh`** once if zsh should be your login shell. You can also use **GNU Stow** via [`../scripts/restow-config.sh`](../scripts/restow-config.sh) (symlinks into `~/.config` / `~` instead of copies).

## Quick start

```sh
cd ~/dotfiles/arch-linux
chmod +x ./install.sh
./install.sh
```

Package names live **in [`install.sh`](install.sh)** as `OFFICIAL_PKGS` (pacman) and `AUR_PKGS` (yay/paru). Edit those arrays, then run the script.

**[`Brewfile`](../Brewfile) parity:** **`bun`** (formula) ↔ Arch **`bun`** (`[extra]`). Browsers: **`google-chrome`**, **`vivaldi`** (`[extra]`), **`zen`** (cask) ↔ Arch **`google-chrome`** + **`zen-browser-bin`** (AUR) + **`vivaldi`** (pacman). Formulas map to `[extra]`/`[core]` where possible; **`python@3.11`** is not installed via AUR `python311` (that rebuilds CPython from source for a long time). The script installs **`uv`** from `[extra]` — run **`uv python install 3.11`** after install for a managed 3.11. `neofetch` → AUR `neofetch`; `mysql` / `mysql@8.0` → `mariadb`; `dotnet` + cask `dotnet-sdk` → `dotnet-runtime` + `dotnet-sdk`; nerd fonts → `otf-*` / `ttf-*` in `[extra]`. **`alt-tab`** (cask) has no Linux equivalent in the script.

Optional: `AUR_HELPER=paru ./install.sh` if you use paru instead of yay. The script uses `--noconfirm` for pacman and the AUR helper.

### Node.js: `nodejs` vs `nodejs-lts-*`

Arch’s **`nodejs`** (current major) **conflicts** with **`nodejs-lts-jod`**, **`nodejs-lts-krypton`**, **`nodejs-lts-iron`**, etc. The script **does not** always install `nodejs`: it only adds **`nodejs`** if no pacman-owned **`/usr/bin/node`** exists (so an existing LTS install is left alone and **`npm`** still resolves against `Provides: nodejs=…` from the LTS package). To switch families later, remove one side explicitly (e.g. `sudo pacman -R nodejs-lts-jod` then re-run the script or `sudo pacman -S nodejs npm`).

After packages, **`install.sh` enables** (best-effort):

- **User:** `pipewire`, `wireplumber`, `pipewire-pulse`, `syncthing`, `hypridle`, `plasma-polkit-agent`, `xdg-desktop-portal-hyprland`, `eww` — warns if enable fails (often no user systemd bus until a graphical login). Hyprland also runs `dbus-update-activation-environment`, **`graphical-session.target`**, **Walker**, and **Elephant** via **`exec-once`** in **`config/hypr/hyprland.conf`** (no custom unit files in this repo).
- **System:** `NetworkManager`, `NetworkManager-dispatcher`, `NetworkManager-wait-online`, `bluetooth`, `docker`, `mariadb` — **no message** if that unit is not installed (e.g. package skipped or removed); **warn** only when the unit exists but `systemctl enable --now` fails (permissions, masked service, or MariaDB failing its first start — check `journalctl -u mariadb`).

`systemctl --user` needs a normal login session (logind); if you run the script over plain SSH with no user dbus, user units may no-op until you log in graphically once and run the `systemctl --user enable --now …` lines yourself.

### If yay fails on `hyprutils-git` / `hyprwayland-scanner-git`

Repo **hyprland** uses stable **hyprutils** and **hyprwayland-scanner** from `[extra]`. AUR **`*-git`** Hypr packages want the `-git` variants of those libraries and **conflict** with the repo packages.

Do **not** put `hyprpicker-git` (or other `hypr*-git` tools) in `AUR_PKGS`. Use **hyprpicker** from `[extra]` — it is already listed in `OFFICIAL_PKGS`.

If an old yay run left bad build deps in the batch, install lists without `-git` Hypr packages, then retry. Optional cleanup: `yay -Yc` (review what it removes).

## Install `yay` (one-time)

```sh
sudo pacman -S --needed base-devel git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Stow / symlinks (important)

```sh
~/dotfiles/scripts/restow-config.sh
```

## Services (manual)

If you need to re-run systemd enables:

```sh
systemctl --user enable --now \
  pipewire.service wireplumber.service pipewire-pulse.service \
  syncthing.service hypridle.service \
  plasma-polkit-agent.service xdg-desktop-portal-hyprland.service
sudo systemctl enable --now \
  NetworkManager.service NetworkManager-dispatcher.service NetworkManager-wait-online.service \
  bluetooth.service docker.service mariadb.service
```

**Walker + Elephant** (same as Hyprland `exec-once`, for a one-off terminal test):

```sh
walker --gapplication-service & elephant &
```

## Folder → package map (configs in this repo)

| Config dir in repo | Typical Arch packages |
|--------------------|------------------------|
| `config/hypr/` | `hyprland`, `hyprpaper`, `hypridle`, `hyprlock`, `hyprshot` (screenshots; also `grim` / `slurp`) |
| `config/eww/` | AUR `eww` (fallback candidates in installer: `eww-wayland`, `eww-git`, `eww-wayland-git`) |
| `config/waybar/` | `waybar` |
| `config/swaync/` | `swaync` |
| `config/kitty/`, `config/alacritty/`, `config/ghostty/` | matching terminal packages; UI monospace stack uses **SF Mono Nerd** — AUR **`nerd-fonts-sf-mono`** ([`../documentation/fonts.md`](../documentation/fonts.md)) |
| `config/fontconfig/`, `config/rofi/` | same AUR font + `fontconfig` snippet for generic `monospace`; Rofi reads `config.rasi` |
| `config/nvim/` | `neovim`, `tree-sitter`, **`tree-sitter-cli`** (required by nvim-treesitter to compile parsers; library-only `tree-sitter` is not enough) — [`../documentation/neovim.md`](../documentation/neovim.md) |
| `config/yazi/` | `yazi` |
| `config/btop/`, `config/htop/`, `config/fastfetch/` | same names |
| `config/starship/` | `starship` (via `STARSHIP_CONFIG` in `home/.zshrc`) |
| `config/bat/` | `bat` |
| `config/neofetch/` | AUR `neofetch` |
| `config/lazygit/` | `lazygit` |
| `config/pipewire/` | `pipewire`, `wireplumber` |
| `home/.tmux.conf` | `tmux` + [TPM](https://github.com/tmux-plugins/tpm) (`install.sh` clones to `~/.tmux/plugins/tpm`, runs `install_plugins`) |
| `home/.zshrc` | `zsh` stack from `install.sh`: plugins, `fzf`, `zoxide`, `starship`; `brew shellenv` if `brew` is on `PATH`; `ls` / `ll` / `lt` → `eza` when `eza` is on `PATH` ([`../documentation/eza.md`](../documentation/eza.md)) |
