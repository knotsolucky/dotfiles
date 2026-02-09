eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

export PATH="$HOME/.bun/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

## fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--style full --border --height 100%"

fzf() {
  local file=$(command fzf --preview 'cat {}')
  if [[ -n "$file" ]]; then
    nvim "$file"
  else
    return 0
  fi
}

## zoxide
eval "$(zoxide init zsh --cmd cd)"

## starship
eval "$(starship init zsh)"

## eza
alias ls='eza --group-directories-first --icons=always --long'

## zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
