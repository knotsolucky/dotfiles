# Waybar (Hyprland)

## Tray

[`config/waybar/config.jsonc`](../config/waybar/config.jsonc): **`tray`** in **`modules-right`**, **`show-passive-items`**. Needs a Waybar build with StatusNotifier + appindicator stack.

## Workspaces + window title

**`hyprland/workspaces`**: **`active-only`: true** — bar lists only the **current** workspace (no 1–10 strip). Switch with **Super+1…0** / gestures. **`sort-by`: `number`**, **`move-to-monitor`: true**, **`enable-bar-scroll`: false**.

**Layout / type:** Right cluster order ends with **`clock#date`**, **`clock#time`**, **`tray`**, **`custom/power`** (tray at the far right). Clock/date formats are **text-only** (no leading icons). **`style.css`**: bar **`font-size` 15px** for left/right pills; **`#clock.time`** 16px, **`#clock.date`** 17px.

**`hyprland/window`**: **`separate-outputs`: true**; **`rewrite`** maps empty title to nothing. **[`style.css`](../config/waybar/style.css)** uses **`window#waybar.empty #window`** to collapse the window pill when the workspace has no tiled clients (stale titles otherwise).

## Hyprland

Workspace **slide** duration in [`hypr/hyprland.conf`](../config/hypr/hyprland.conf) is slightly shorter than default so switches feel snappier.
