# Dotfiles layout and deploy

## Where configs live

- **`config/`** — everything that belongs under **`$XDG_CONFIG_HOME`** (usually `~/.config/`). Each immediate child directory is one app namespace (`config/hypr/`, `config/nvim/`, `config/tmux/`, …).
- **`home/`** — dotfiles in **`$HOME`** (e.g. **`home/.zshrc`** → **`~/.zshrc`**). **`install.sh`** runs **`cp -a home/. ~`**; **`restow-config.sh`** runs **`stow -t ~ home`** (symlinks). Do not mix copy and stow for the same file without cleaning up first.

## Two ways to install them onto `~/.config`

1. **`arch-linux/install.sh`** — after packages, **copies** each `config/<app>/` into `~/.config/<app>/` (`cp -a`). Overwrites/merges files in place; not symlinks.

2. **`scripts/restow-config.sh`** — uses **GNU Stow** with `-d config` so each package is symlinked into `~/.config/<app>/`. Handy when you edit files in the repo and want live updates without re-running the Arch installer.

Pick one workflow per machine; mixing copy + stow for the same app can be confusing.

## Shell and tmux

- **`home/.zshrc`** sources Arch **`zsh-autosuggestions`**, **`fzf`**, **`zsh-syntax-highlighting`** and runs **`zoxide init`** / **`starship init`**. Other CLI tools from **`install.sh`** you invoke directly (**`eza`**, **`bat`**, …). Login shell: **`chsh -s /bin/zsh`** (once).
- **`config/tmux/tmux.conf`** is read from **`~/.config/tmux/tmux.conf`** (tmux XDG layout).

## Hyprland session

Hyprland reads **`~/.config/hypr/`** after either method. Walker, Elephant, and **`graphical-session.target`** are started from **`exec-once`** there.
