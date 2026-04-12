# Fonts in this repo

## UI stack (JetBrains Mono)

**Waybar**, **SwayNC** (CSS + `config.yaml`), **wlogout**, **eww**, and **hyprlock** use:

`JetBrainsMono Nerd Font` → fallback `JetBrains Mono` → `monospace`.

Install **Nerd-patched** JetBrains on Arch: **`ttf-jetbrains-mono-nerd`** (already listed in **`arch-linux/install.sh`**). On macOS, Homebrew **`font-jetbrains-mono-nerd-font`** in **`macos/Brewfile`**.

## Terminal emulators (unchanged here)

**Kitty**, **Alacritty**, and **Ghostty** each set **their own** `font_family` / `[font]` in **`config/kitty/`**, **`config/alacritty/`**, **`config/ghostty/`** — not overridden by the JetBrains UI rule. Adjust those files if you want terminals on JetBrains too.

For SF-style terminals, keep **AUR `nerd-fonts-sf-mono`** (or equivalent) so names like **`SFMono Nerd Font`** resolve.
