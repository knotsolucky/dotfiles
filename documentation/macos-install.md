# macOS Install Notes

## Shell profile

`macos/install.sh` now applies a macOS-specific shell profile:

- Source: `macos/.zshrc`
- Target: `$HOME/.zshrc`
- Order: copied **after** `home/` dotfiles, so macOS settings override Linux-oriented defaults.

## macOS `.zshrc` behavior

Includes:

- truecolor + `EDITOR=nvim`
- history sizing/options
- optional Homebrew shellenv
- `compinit`
- plugin loading from `~/.zsh/plugins/`
- optional `~/.fzf.zsh`
- zoxide + starship init
- eza aliases guarded by command check

This keeps paths portable on macOS and avoids `/usr/share/...` Linux plugin paths.
