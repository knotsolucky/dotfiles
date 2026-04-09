export EDITOR=nvim VISUAL=nvim
export HISTFILE=~/.zsh_history HISTSIZE=50000 SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY
bindkey -e
autoload -Uz compinit && compinit

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
