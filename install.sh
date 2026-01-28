#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"

echo "Installing dotfiles..."
echo "Existing configs will be backed to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

backup_and_link() {
  local target="$1"
  local source="$2"
  
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Backing up $target"
    mv "$target" "$BACKUP_DIR/"
  fi
  
  mkdir -p "$(dirname "$target")"
  ln -sf "$source" "$target"
}

# Zsh
echo "Installing Zsh configs..."
backup_and_link ~/.zshrc "$DOTFILES/zsh/.zshrc"
backup_and_link ~/.p10k.zsh "$DOTFILES/zsh/.p10k.zsh"

# Neovim
echo "Installing Neovim config..."
backup_and_link ~/.config/nvim "$DOTFILES/nvim"

# Git
echo "Installing Git configs..."
backup_and_link ~/.gitconfig "$DOTFILES/git/.gitconfig"
backup_and_link ~/.config/git/ignore "$DOTFILES/git/ignore"

# Ghostty
echo "Installing Ghostty config..."
backup_and_link ~/.config/ghostty/config "$DOTFILES/other/ghostty/config"

echo ""
echo "✓ Dotfiles installed successfully!"
echo "✓ Backups saved to: $BACKUP_DIR"
echo "Restart your shell to apply changes."
