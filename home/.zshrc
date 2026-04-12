export EDITOR=nvim HISTFILE=~/.zsh_history HISTSIZE=50000 SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

autoload -Uz compinit && compinit

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

eval "$(zoxide init zsh)"
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
eval "$(starship init zsh)"

alias ls='eza --icons --group-directories-first'
alias ll='eza -lbhHigUmuSa --time-style=long-iso --icons --color-scale'
alias lt='eza --tree --level=2'

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
