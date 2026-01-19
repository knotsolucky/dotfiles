
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# Zsh Autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zoxide
eval "$(zoxide init zsh --cmd cd)"

# Zsh Syntax Highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 

# Starship
eval "$(starship init zsh)"

# Eza (ls replacement)
alias ls='eza --group-directories-first --icons=always'

# Bun completion
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"



