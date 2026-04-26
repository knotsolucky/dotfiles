# Config sync workflow

`bash scripts/sync-all-config.sh` (from the dotfiles repo) **overwrites** matching paths under `$XDG_CONFIG_HOME` (~/.config) with the contents of **`config/`** in this repository.

Hyprland **hyprsplit** is under `config/hypr/`, but the plugin comes from **hyprpm**. After `sync-all-config.sh`, run **`bash scripts/ensure-hyprsplit.sh`** or **`bash scripts/restow-config.sh`** (sync + ensure-hyprsplit + stow `home/`).

**Workflow:** edit files under **`~/dotfiles/config/...`**, then run sync (or `arch-linux/install.sh`, which calls sync). If you only edit `~/.config/...`, the next sync will replace those edits.

**Recover after a mistaken sync:** your last committed / saved dotfiles tree is the restore point; run sync again from that tree. For one-off overrides without syncing over them, use a Hyprland `source` of a file you keep outside `config/` or add patterns to `sync-all-config.sh`’s exclude list (advanced).
