#!/usr/bin/env bash
set -e

# Ensure Homebrew exists
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


echo "Installing formulae..."
brew install \
bash \
bat \
docker \
gcc \
ffmpeg \
go \
mysql \
mysql@8.0 \
neofetch \
neovim \
node \
openjdk \
openvpn \
putty \
python@3.11 \
rust \
starship \
tmux \
tree \
lazygit \
zsh-syntax-highlighting \
zsh-autosuggestions \
zoxide \
zsh \
yazi \
gh \
llvm \
unzip \
zip \
npm \
dotnet \
eza \
maven \
lua \
cmake \
make \
raylib \
sdl2

echo "Installing casks..."
brew install --cask \
alacritty \
alt-tab \
discord \
dotnet-sdk \
font-fira-code \
font-geist-mono-nerd-font \
font-jetbrains-mono-nerd-font \
font-iosevka-term-nerd-font \
font-fira-code-nerd-font \
raycast \
obsidian \
tidal \
unnaturalscrollwheels \
visual-studio-code \
whatsapp \
wireshark \
google-chrome \
ghostty \
zen-browser \
macs-fan-control \
cursor \
1password \
firefox

echo "✅ Homebrew installation complete!"

