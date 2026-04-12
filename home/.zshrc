# 1. Environment Variables
export EDITOR=nvim
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export TERM='xterm-256color'

# 2. Zsh Options
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# 3. External Tool Initializations
command -v brew >/dev/null && eval "$(brew shellenv)"
eval "$(zoxide init zsh)"

# 4. Completions (Must be initialized before plugins)
autoload -Uz compinit && compinit

# 5. Aliases (eza)
if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lbhHigUmuSa --time-style=long-iso --icons --color-scale'
  alias lt='eza --tree --level=2'
fi

# 6. FZF Key Bindings & Completion
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# 7. Visual Plugins (ORDER MATTERS HERE)
# Prompt first
eval "$(starship init zsh)"

# Autosuggestions second
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting ALWAYS LAST
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
