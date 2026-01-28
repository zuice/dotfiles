#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_NAME="FiraCode Nerd Font"
FONT_INSTALLED=0

echo "Checking dependencies..."

# Check for Ghostty font
if fc-list | grep -qi "FiraCode Nerd Font"; then
  echo "✓ $FONT_NAME already installed"
  FONT_INSTALLED=1
else
  echo "✗ $FONT_NAME not found"
fi

# Function to install fonts on Arch/Manjaro
install_fonts_arch() {
  echo "Installing fonts on Arch/Manjaro..."
  sudo pacman -S --noconfirm ttf-nerd-fonts-symbols ttf-firacode-nerd
}

# Function to install fonts on Ubuntu/Debian
install_fonts_ubuntu() {
  echo "Installing fonts on Ubuntu/Debian..."
  sudo apt-get update
  sudo apt-get install -y fonts-firacode
  # Download and install Nerd Font variant
  wget -P /tmp https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
  sudo mkdir -p /usr/share/fonts/truetype/firacode-nerd
  sudo unzip -o /tmp/FiraCode.zip -d /usr/share/fonts/truetype/firacode-nerd
  sudo fc-cache -f
  rm /tmp/FiraCode.zip
}

# Function to install fonts on macOS
install_fonts_macos() {
  echo "Installing fonts on macOS..."
  brew tap homebrew/cask-fonts
  brew install font-fira-code-nerd-font
}

if [ $FONT_INSTALLED -eq 0 ]; then
  echo ""
  echo "Install $FONT_NAME?"
  read -p "y/N: " install
  
  if [[ $install =~ ^[Yy]$ ]]; then
    if [ -f /etc/arch-release ]; then
      install_fonts_arch
    elif [ -f /etc/debian_version ]; then
      install_fonts_ubuntu
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      install_fonts_macos
    else
      echo "Unsupported OS. Please install $FONT_NAME manually."
      exit 1
    fi
    echo "✓ Fonts installed"
  fi
fi

echo ""
echo "Setup complete!"
