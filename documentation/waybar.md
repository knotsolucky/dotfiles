# Waybar (Hyprland)

## Tray

[`config/waybar/config.jsonc`](../config/waybar/config.jsonc): **`tray`** in **`modules-right`**, **`show-passive-items`**. Needs a Waybar build with StatusNotifier + appindicator stack.

## Workspaces + window title

**`hyprland/workspaces`**: **`persistent-workspaces`** for **`"*": [1…10]`** matches Super+1…0 so buttons stay stable (fewer layout thrashes / odd clicks when Hyprland had no workspace entries yet). **`sort-by`: `number`**, **`move-to-monitor`: true**, **`enable-bar-scroll`: false** (avoid accidental workspace cycling from the bar).

**`hyprland/window`**: **`separate-outputs`: true**; **`rewrite`** maps empty title to nothing. **[`style.css`](../config/waybar/style.css)** uses **`window#waybar.empty #window`** to collapse the window pill when the workspace has no tiled clients (stale titles otherwise).

## Hyprland

Workspace **slide** duration in [`hypr/hyprland.conf`](../config/hypr/hyprland.conf) is reduced so switches feel less “spazzy”.
