#!/usr/bin/env bash
# Floating fastfetch with rounded Unicode frame + Hyprland window rounding (class: fetch-ui).
set -e
INNER="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/fetch-ui-inner.sh"
exec kitty --class fetch-ui \
  --title "System" \
  -o remember_window_size=no \
  -o initial_window_width=480 \
  -o initial_window_height=380 \
  -o window_padding_width=18 \
  -o window_padding_height=16 \
  -o font_size=10 \
  -o foreground=#e5e5e5 \
  -o background=#0f0f0f \
  -o cursor_shape=beam \
  -e bash "$INNER"
