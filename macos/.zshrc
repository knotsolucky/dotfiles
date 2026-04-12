export COLORTERM=truecolor
export EDITOR=nvim
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

eval "$(brew shellenv)"

autoload -Uz compinit && compinit

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

eval "$(zoxide init zsh)"
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
eval "$(starship init zsh)"

alias ls='eza --icons --group-directories-first'
alias ll='eza -lbhHigUmuSa --time-style=long-iso --icons --color-scale'
alias lt='eza --tree --level=2'

source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
