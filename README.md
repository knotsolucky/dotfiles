# Dotfiles

Single entrypoint: **`scripts/dotfiles.sh`**

| Command | Action |
|--------|--------|
| `dotfiles.sh` / `dotfiles.sh push` | `config/` → `~/.config`, `stow` `home/`, hyprsplit |
| `dotfiles.sh config` | config sync only (macOS install uses this) |
| `dotfiles.sh pull [--delete] [--dry-run]` | copy `~/.config` → repo for entries already under `config/` |

Starship: single `config/starship.toml` everywhere (no per-OS files).

### Arch Linux

**`arch-linux/install.sh`** installs **`git`** + **`stow`**, runs **`dotfiles.sh`** (config + home + hyprsplit), **`pacman`** (incl. **`base-devel`**), builds **`yay`** from AUR if missing, then **`yay`** for **AUR** packages. Enables **`ufw`**: deny inbound by default, **SSH (22)** from anywhere; **Next.js (3000/3001), Vite (5173), Metro (8081), Expo (19000/19001), LocalSend (53317 tcp+udp)** from private LAN subnets only (`10/8`, `172.16/12`, `192.168/16`).

### macOS

1. Install [MacPorts](https://www.macports.org/install.php).
2. Run **`macos/install.sh`** — **`dotfiles.sh config`**, copy **`home/`**, **`macos/.zshrc`**, then **`port install`** from **`macos/ports.txt`** (`/opt/local` paths).
3. Former Homebrew casks (GUI/fonts): **`macos/GUI.md`**.
4. **`SKIP_PORT_SELFUPDATE=1`** skips `sudo port selfupdate` for quicker repeats.
