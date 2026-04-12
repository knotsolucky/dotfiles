# macOS — Homebrew + dotfiles config

Installs formulae and casks from **[`Brewfile`](Brewfile)** via **`brew bundle`**, then runs **[`../scripts/sync-all-config.sh`](../scripts/sync-all-config.sh)** so **`config/`** is copied into **`$XDG_CONFIG_HOME`** (including **top-level files** there). On **macOS**, **Hyprland / Wayland–related** dirs are **skipped by default**; see **[`../documentation/config-sync.md`](../documentation/config-sync.md)**. Optionally copies **[`../home/`](../home/)** into **`$HOME`** and bootstraps **tpm** for tmux.

This path **does not** install Hyprland, Wayland tools, systemd units, NetworkManager, MariaDB init, Elephant/Walker, or other Linux-only pieces. Use **[`../arch-linux/`](../arch-linux/)** for that stack.

## Quick start

```sh
cd ~/dotfiles/macos
chmod +x ./install.sh
./install.sh
```

Requires **Command Line Tools** or Xcode toolchain for some builds; Homebrew will prompt when needed.

## Docs

- **[`../documentation/config-sync.md`](../documentation/config-sync.md)** — how `config/` sync works.
- **[`../documentation/macos-install.md`](../documentation/macos-install.md)** — macOS-specific notes.

## Brewfile parity

Rough alignment with **[`../arch-linux/install.sh`](../arch-linux/install.sh)** package intent is described in the Brewfile footer and **[`../arch-linux/README.md`](../arch-linux/README.md)** (Brewfile row now points here).
