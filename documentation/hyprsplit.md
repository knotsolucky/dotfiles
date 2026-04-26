# hyprsplit (separate workspaces per monitor)

Stock Hyprland uses **one** global workspace id per number. **[hyprsplit](https://github.com/shezdy/hyprsplit)** gives each output its own **1–10** (or `num_workspaces`) so DP and HDMI do not share the same workspace 6.

Config lives in `config/hypr/hyprland.conf`: `plugin { hyprsplit { ... } }`, `exec-once = hyprpm reload -n`, and binds using `split:workspace` / `split:movetoworkspacesilent` / `split:workspace` for scroll.

The **`.so`** is not in git; this repo ships **Hyprland config** plus **`scripts/ensure-hyprsplit.sh`** (hyprpm add / enable / reload). It runs from **`arch-linux/install.sh`** and **`scripts/restow-config.sh`** after `sync-all-config.sh`.

## Install

**Arch (`arch-linux/install.sh`):** after syncing config, runs `scripts/ensure-hyprsplit.sh`. Log back into Hyprland (or `hyprctl reload`) if the session was already running.

**Sync only:** run `bash scripts/ensure-hyprsplit.sh`, or `bash scripts/restow-config.sh` (sync + hyprsplit + stow `home/`).

**Manual (hyprpm):**

```bash
hyprpm update
yes | hyprpm add https://github.com/shezdy/hyprsplit   # non-interactive confirm
hyprpm enable hyprsplit
hyprpm reload
hyprctl reload
```

Install **before** reloading a config that contains `split:*` binds, or Hyprland will reject unknown dispatchers.

Build deps on Arch: `hyprland` headers (often `hyprland-git` / `hyprland` plus base-devel). See [Hyprland plugins](https://wiki.hypr.land/Plugins/Using-Plugins/).

If `hyprctl reload` errors on `split:*` or `plugin { hyprsplit`, the `.so` is not loaded — finish `hyprpm enable` and ensure `exec-once = hyprpm reload -n` runs (already in this repo’s `hyprland.conf`).

## This repo’s options

- `num_workspaces = 10`
- `persistent_workspaces = false` — avoids creating all 10 empty workspaces on each head (Waybar was listing 1–10 as if they all existed). Set `true` if you prefer every slot always addressable.
- `monitor_priority = DP-1,HDMI-A-1` — internal id ranges favour DP first (adjust if you rename outputs)

**Primary monitor:** `hyprland.conf` puts **DP-1 at `0x0`** and HDMI left at **`-2560x0`**. If the HDMI Waybar glitches again (layer-shell + negative X), switch back to all-positive layout (HDMI `0x0`, DP `2560x0`) and keep `monitor_priority` for hyprsplit only.

## Optional

- `hyprctl dispatch split:grabroguewindows` after unplugging a monitor (bind yourself; `Super+G` is window groups here)
- `split:swapactiveworkspaces, current +1` — swap active workspaces between two heads
