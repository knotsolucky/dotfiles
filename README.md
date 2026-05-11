# Dotfiles

Single entrypoint: **`scripts/dotfiles.sh`**

| Command | Action |
|--------|--------|
| `dotfiles.sh` / `dotfiles.sh push` | `config/` → `~/.config`, `stow` `home/`, hyprsplit |
| `dotfiles.sh config` | config sync only (macOS install uses this) |
| `dotfiles.sh pull [--delete] [--dry-run]` | copy `~/.config` → repo for entries already under `config/` |

Starship: single `config/starship.toml` everywhere (no per-OS files).

### Arch Linux

**`arch-linux/install.sh`** installs **`git`** + **`stow`**, runs **`dotfiles.sh`** (config + home + hyprsplit), then **`pacman`** / **AUR** packages.

### macOS

1. Install [MacPorts](https://www.macports.org/install.php).
2. Run **`macos/install.sh`** — **`dotfiles.sh config`**, copy **`home/`**, **`macos/.zshrc`**, then **`port install`** from **`macos/ports.txt`** (`/opt/local` paths).
3. Former Homebrew casks (GUI/fonts): **`macos/GUI.md`**.
4. **`SKIP_PORT_SELFUPDATE=1`** skips `sudo port selfupdate` for quicker repeats.
