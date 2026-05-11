export COLORTERM=truecolor
export EDITOR=nvim
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# MacPorts — https://guide.macports.org/#installing.shell
MP="${MACPORTS_PREFIX:-/opt/local}"
export PATH="$MP/bin:$MP/sbin:$PATH"
export MANPATH="$MP/share/man:$MANPATH"

autoload -Uz compinit && compinit

[[ -r "$MP/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$MP/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -r "$MP/share/fzf/shell/completion.zsh" ]] && source "$MP/share/fzf/shell/completion.zsh"
[[ -r "$MP/share/fzf/shell/key-bindings.zsh" ]] && source "$MP/share/fzf/shell/key-bindings.zsh"

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

eval "$(starship init zsh)"

if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lbhHigUmuSa --time-style=long-iso --icons --color-scale'
  alias lt='eza --tree --level=2'
fi

[[ -r "$MP/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$MP/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
