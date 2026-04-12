# Syncing `config/` → `~/.config`

## Behavior

[`scripts/sync-all-config.sh`](../scripts/sync-all-config.sh) mirrors **all** immediate children of the repo’s **`config/`** directory into **`$XDG_CONFIG_HOME`** (usually **`~/.config`**):

| Under `config/` | Becomes |
|-----------------|--------|
| Directory `foo/` | `~/.config/foo/` (full tree merged with `cp -a`) |
| Regular file `bar` | `~/.config/bar` |

There is **no** per-application allowlist in the script.

## Skipping entries (`DOTFILES_SYNC_EXCLUDE`)

Set **`DOTFILES_SYNC_EXCLUDE`** to a **space-separated** list of **names** matching top-level entries under **`config/`** (directory or file). Those entries are not copied.

**macOS:** if **`DOTFILES_SYNC_EXCLUDE` is unset**, the script sets a default list so Hyprland / Wayland session configs are not deployed: **`hypr`**, **`HyprPaper`**, **`waybar`**, **`swaync`**, **`wlogout`**, **`eww`**, **`pipewire`**. Everything else under **`config/`** (including any **loose files** next to those folders) still syncs.

- **Sync everything on macOS:** `DOTFILES_SYNC_EXCLUDE='' bash scripts/sync-all-config.sh` (empty string = set but no tokens → nothing skipped; default is not applied when the variable is set, even to empty).
- **Custom skips:** `DOTFILES_SYNC_EXCLUDE='waybar foo.json' bash scripts/sync-all-config.sh`

Linux / Ubuntu / Arch installs do **not** apply the macOS default; leave **`DOTFILES_SYNC_EXCLUDE`** unset for a full mirror.

## When it runs

- **`arch-linux/install.sh`** — after pacman + AUR installs, before systemd / Elephant steps.
- **`ubuntu/install.sh`** — after `apt-get install`, before `home/` and TPM steps.
- **`macos/install.sh`** — after `brew bundle`, before optional `home/` copy and TPM.
- **Manual:** `bash ~/dotfiles/scripts/sync-all-config.sh` or **`~/dotfiles/scripts/restow-config.sh`** (config copy + optional `stow` for `home/`).

## Notes

- **`cp -a`** keeps modes and timestamps; the repo stays intact (this is a **copy**, not `mv`).
- **`DRY_RUN=1`** — prints what would sync without writing: `DRY_RUN=1 bash scripts/sync-all-config.sh`.
