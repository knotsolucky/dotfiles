# OLED Boxed Theme Tokens

This theme keeps the current accent palette and switches geometry from pills to boxed cards.

## Color tokens

- `--oled-bg`: `#000000`
- `--oled-panel`: `#050505`
- `--oled-card`: `#0c0c0c`
- `--oled-card-strong`: `#121212`
- `--oled-border`: `rgba(255, 255, 255, 0.10)`
- `--oled-border-soft`: `rgba(255, 255, 255, 0.08)`
- `--oled-text`: `#ffffff`
- `--accent-cyan`: `#7dd3fc`
- `--accent-sky`: `#38bdf8`
- `--accent-violet`: `#c4b5fd`
- `--accent-amber`: `#fcd34d`
- `--accent-mint`: `#6ee7b7`
- `--accent-danger`: `#f87171`

## Geometry tokens

- Global container radius: `8px`
- Card/button radius: `6px`
- Container border: `1px solid rgba(255, 255, 255, 0.10)`
- Card border: `1px solid rgba(255, 255, 255, 0.08)`
- Outer spacing rhythm: multiples of `4px`

## Font

- UI family: `"JetBrainsMono Nerd Font", "JetBrains Mono", monospace`

## Scope

Applies to:

- `config/waybar/`
- `config/swaync/`
- `config/wlogout/`
- `config/hypr/hyprland.conf` (gaps, borders, rounding)

Terminal emulator fonts stay independent in:

- `config/kitty/`
- `config/alacritty/`
- `config/ghostty/`

## OLED blur note

For maximum black levels on OLED panels, disable Hyprland blur (`decoration.blur.enabled = false`).
Current default keeps blur enabled for readability and depth.
