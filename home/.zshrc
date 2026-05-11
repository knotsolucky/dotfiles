export EDITOR=nvim
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export TERM='xterm-256color'

setopt HIST_IGNORE_DUPS SHARE_HISTORY

command -v brew >/dev/null && eval "$(brew shellenv)"

autoload -Uz compinit && compinit

if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lbhHigUmuSa --time-style=long-iso --icons --color-scale'
  alias lt='eza --tree --level=2'
fi

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

eval "$(starship init zsh)"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ -o interactive ]] && (( $+commands[fastfetch] )); then
  fastfetch
fi
