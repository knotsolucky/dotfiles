# Dotfiles workflow (GNU Stow)

## Where the truth lives

- **Canonical configs** live in `~/dotfiles`, one directory per XDG app name (`hypr/`, `waybar/`, …).
- After setup, files under `~/.config/<app>/` are **symlinks into** `~/dotfiles/<app>/`, so editing either path changes the same file.
- **Commit and push** from `~/dotfiles` only.

## Day to day

1. Edit configs as usual (paths under `~/.config/...` are fine).
2. `cd ~/dotfiles && git add -p && git commit && git push`

No manual copying from `~/.config` into the repo.

## New machine

1. Install [GNU Stow](https://www.gnu.org/software/stow/) (Arch: `sudo pacman -S stow`).
2. Clone this repository to `~/dotfiles` (or set `DOTFILES_ROOT` in your head and adjust paths).
3. Run the restow script once:

   ```sh
   ~/dotfiles/scripts/restow-config.sh
   ```

## One-time migration (already using plain directories under `~/.config`)

If `~/.config/<app>` is a real directory, Stow cannot replace it with symlinks until you move it aside.

1. **Merge** anything newer from `~/.config` into `~/dotfiles` so you do not lose edits (example):

   ```sh
   cp -au ~/.config/hypr/. ~/dotfiles/hypr/
   ```

   Repeat per app, or diff first: `diff -ru ~/dotfiles/hypr ~/.config/hypr`.

2. **Rename** the live config dir:

   ```sh
   mv ~/.config/hypr ~/.config/hypr.bak
   ```

3. Run `~/dotfiles/scripts/restow-config.sh`.

4. Confirm apps still work, then remove backups: `rm -rf ~/.config/hypr.bak`.

If you renamed every tracked app at once, you can remove all backups in one go (only after restow succeeds):

```sh
rm -rf ~/.config/*.bak
```

Do this per package if you only migrate a subset first.

## Restow script

- Path: `scripts/restow-config.sh`
- Uses `stow -R` (restow): safe to run again after adding files to the repo.
- **Per-package target** (`-t "$XDG_CONFIG_HOME/<pkg>"`): GNU Stow maps a package’s files into the target directory **without** adding the package name. A single `-t ~/.config` would put `hypr/hyprland.conf` at `~/.config/hyprland.conf` (wrong for XDG) and make names like `config.jsonc` collide across apps. The script stows each package into its own `~/.config/<pkg>/` tree.
- Creates each `~/.config/<pkg>/` with `mkdir -p` if needed (Stow requires an existing target directory).
- Base config dir: `$XDG_CONFIG_HOME` if set, otherwise `$HOME/.config`.
- **Allowlisted packages only** — `yay/` and other non-config trees in this repo are not stowed.

## Troubleshooting

- **Stow reports conflicts**: A file or directory already exists where Stow needs a symlink. Remove or rename the blocking path (or merge into `~/dotfiles` first), then run the restow script again.
- **`stow: command not found`**: Install Stow (see above).

## Repo-specific notes

- `Brewfile` at the repo root is not managed by Stow; keep it as a normal tracked file.
- `yay/` is ignored in git — it is not an XDG config package; do not stow it.
- **Arch Linux:** package lists and installer live in [`../arch-linux/README.md`](../arch-linux/README.md).
