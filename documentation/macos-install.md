# macOS install (`macos/install.sh`)

## What runs

1. **`brew bundle install --file=macos/Brewfile`** — formulae + casks (no Hyprland / Wayland / systemd).
2. **`scripts/sync-all-config.sh`** — **`config/`** → **`~/.config`**, including **top-level files** under **`config/`** if you add any. On **Darwin**, **Hyprland / Wayland–related** dirs are **skipped by default** (`hypr`, `HyprPaper`, `waybar`, `swaync`, `wlogout`, `eww`, `pipewire`). Override with **`DOTFILES_SYNC_EXCLUDE=''`** for a full copy. See **[`config-sync.md`](config-sync.md)**.
3. If **`home/`** exists: copy dotfiles into **`$HOME`**, **`chmod 600`** on **`.zshrc`** / **`.tmux.conf`** when present.
4. **TPM** clone + **`install_plugins`** when possible (same idea as **`ubuntu/install.sh`**).

## What does *not* run

- **systemd**, **NetworkManager**, **MariaDB** install-db, **Docker** Linux socket setup (use **Docker Desktop** from the Brewfile cask).
- **Hyprland**, **Waybar**, **swaync**, **wlogout**, **walker**, **elephant**, **pipewire**, etc.

## After install

- **Docker:** open Docker Desktop once so the engine starts.
- **Syncthing:** `brew services start syncthing` or run the app as you prefer.
- **Python 3.11:** Brewfile includes **`python@3.11`**; optional **`uv python install 3.11`** for a uv-managed interpreter (see **`arch-linux/README.md`** Brew parity note).
