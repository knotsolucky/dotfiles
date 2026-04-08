# Arch Linux setup (this dotfiles repo)

Use this folder to install **packages** that match the apps configured in `~/dotfiles`. Config files themselves are deployed with **GNU Stow** via [`../scripts/restow-config.sh`](../scripts/restow-config.sh) (see [`../documentation/dotfiles-workflow.md`](../documentation/dotfiles-workflow.md)).

## Quick start

```sh
cd ~/dotfiles/arch-linux
chmod +x ./install.sh
./install.sh
```

- Installs everything listed in [`packages.official`](packages.official) with `pacman` (**`--noconfirm`** by default).
- If `yay` is installed, installs [`packages.aur`](packages.aur) next (**`yay -S --noconfirm`** by default).

Flags:

| Flag | Meaning |
|------|--------|
| `--official-only` | Only `pacman` |
| `--aur-only` | Only `yay` (after official deps are satisfied) |
| `--confirm` | Turn off `--noconfirm` for `pacman` and `yay` (prompts for each step) |

## Install `yay` (one-time)

`yay` is not in the main repos:

```sh
sudo pacman -S --needed base-devel git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

Then run `./install.sh --aur-only` if you already ran the official pass.

## Stow / symlinks (important)

This repo expects **per-app targets**, not `stow -t ~/.config hypr waybar` (that flattens names and breaks XDG paths). Always use:

```sh
~/dotfiles/scripts/restow-config.sh
```

## Optional: Walker + Elephant user services

After installing the Walker/Elephant AUR packages (if you use them):

```sh
systemctl --user enable --now elephant.service
# Optional, if the package ships a user unit:
systemctl --user enable --now walker.service 2>/dev/null || true
```

Check status:

```sh
systemctl --user status elephant
```

## Optional: Hyprland-related user services (audio)

Often PipeWire is socket-activated; if you want explicit units:

```sh
systemctl --user enable --now pipewire.service wireplumber.service
```

## Optional: system services (typical workstation)

```sh
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
```

## Zsh plugins on Arch

These match common `source` lines in `.zshrc`:

```sh
sudo pacman -S --needed zsh-autosuggestions zsh-syntax-highlighting zsh-completions
```

Paths are typically:

- `/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh`
- `/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`

## Customising package sets

Edit [`packages.official`](packages.official) and [`packages.aur`](packages.aur), then re-run `./install.sh`. Remove lines you do not want; lines starting with `#` are comments.

## Folder → package map (configs in this repo)

| Config dir in repo | Typical Arch packages |
|--------------------|------------------------|
| `hypr/` | `hyprland`, `hypridle`, `hyprlock` |
| `waybar/` | `waybar` |
| `swaync/` | `swaync` |
| `kitty/`, `alacritty/`, `ghostty/` | matching terminal packages |
| `nvim/` | `neovim` |
| `yazi/` | `yazi` |
| `btop/`, `htop/`, `fastfetch/` | same names |
| `pipewire/` | `pipewire`, `wireplumber` |

Add a `walker/` (or `elephant/`) directory to the repo and extend [`../scripts/restow-config.sh`](../scripts/restow-config.sh) if you track those configs here.
