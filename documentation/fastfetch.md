# Fastfetch

## Files

- [`config/fastfetch/config.jsonc`](../config/fastfetch/config.jsonc)
- [`config/fastfetch/config-kitty-image.jsonc`](../config/fastfetch/config-kitty-image.jsonc) (copy of `config.jsonc`)

## Right column (`│`) alignment

Values are different lengths, so a literal ` \u2502` after `{result}` staggers the right edge.

Each row **`format`** ends with **`\u001b[66G\u2502`**: **CHA** (cursor horizontal absolute) to **column 66**, then the box **`│`**. That lines the right bar up with the top/bottom rules (**66** cells wide: **`┌`** + **64** **`─`** + **`┐`**).

If a value is longer than the space from the fastfetch value column to column **65**, it can collide with the bar — widen the frame: add **`─`** pairs in both **`custom`** border `format` strings and bump **`66`** in every **`format`** (and the colors **`custom`** line) together.

## Colors row

The built-in **`colors`** module does not honor a trailing bar in **`format`** here, so that row is a **`custom`** line that prints the same eight **`●`** swatches plus **`\u001b[66G\u2502`**.

## Layout / colours

- **`logo`:** **`null`**
- **Keys:** purple (`bright_magenta`), **values:** white, **`hname`** gray (`bright_black`).
- **Memory:** **`{used} / {total}`** (no ASCII `|`).

## `home/.zshrc`

Interactive shells run **`fastfetch`** (no image wrapper). Point **`~/.config/fastfetch/config.jsonc`** at this repo file if you want this config by default.
