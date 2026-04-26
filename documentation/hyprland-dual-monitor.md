# Hyprland: DP-1 + HDMI-A-1

## Layout (`config/hypr/hyprland.conf`)

- **DP-1** (ultrawide): primary at **`0x0`**, `3440x1440@175`.
- **HDMI-A-1** (left): **`preferred`**, **`−2560x0`** (one logical width left of DP). If Waybar on HDMI glitches, use all-positive coords instead (HDMI `0x0`, DP `2560x0`) and keep hyprsplit `monitor_priority`.

## Waybar

`config/waybar/config.jsonc`: **two** configs in a JSON array (`waybar-dp` / `waybar-hdmi`), `output` set per head. **Tray** only on **DP-1**. Autostart: `sleep 0.5 && waybar`.

## HyprPaper / Eww

- `config/hypr/hyprpaper.conf`: one `wallpaper` block per monitor (DP listed first).
- Eww `defwindow bar` uses `:monitor 0` → primary = **DP-1** with the current monitor order.

## Workspaces

Per-monitor stacks use **hyprsplit** (`split:*` binds). See `documentation/hyprsplit.md`.

## Sync

`scripts/sync-all-config.sh` copies **`dotfiles/config/` → `~/.config`**, overwriting files there. Treat **`~/dotfiles/config/`** as source of truth (or commit + pull), then sync — do not rely only on edits under `~/.config` if you run sync again.
