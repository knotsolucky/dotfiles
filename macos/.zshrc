# 1. Terminal Colors & Editor
export COLORTERM=truecolor
export EDITOR=nvim
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# 2. Homebrew (if installed)
command -v brew >/dev/null && eval "$(brew shellenv)"

# 3. Autocomplete
autoload -Uz compinit && compinit

# 4. Plugins (Portable Paths)
# Git clone plugin repos to ~/.zsh/plugins/ for this to load.
[[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 5. FZF (Portable Path)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# 6. Tools (Zoxide, Starship)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
command -v starship >/dev/null && eval "$(starship init zsh)"

# 7. Aliases (eza)
if (( $+commands[eza] )); then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lbhHigUmuSa --time-style=long-iso --icons --color-scale'
    alias lt='eza --tree --level=2'
fi
