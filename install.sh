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

# Starship
if command -v starship &>/dev/null; then
  echo "Installing Starship config..."
  backup_and_link ~/.config/starship.toml "$DOTFILES/other/starship/starship.toml"
else
  echo "Skipping Starship config (not installed)"
fi

# Neovim
echo "Installing Neovim config..."
backup_and_link ~/.config/nvim "$DOTFILES/nvim"

# Git
echo "Installing Git configs..."
backup_and_link ~/.gitconfig "$DOTFILES/git/.gitconfig"
backup_and_link ~/.config/git/ignore "$DOTFILES/git/ignore"

# Ghostty
if command -v ghostty &>/dev/null; then
  echo "Installing Ghostty config..."
  backup_and_link ~/.config/ghostty/config "$DOTFILES/other/ghostty/config"
else
  echo "Skipping Ghostty config (not installed)"
fi

# Hyprland
if command -v Hyprland &>/dev/null; then
  echo "Installing Hyprland configs..."
  backup_and_link ~/.config/hypr/hyprland.conf "$DOTFILES/other/hypr/hyprland.conf"
  backup_and_link ~/.config/hypr/hyprlock.conf "$DOTFILES/other/hypr/hyprlock.conf"
  backup_and_link ~/.config/hypr/hypridle.conf "$DOTFILES/other/hypr/hypridle.conf"
  backup_and_link ~/.config/hypr/assets "$DOTFILES/other/hypr/assets"

  if command -v waybar &>/dev/null; then
    echo "Installing Waybar config..."
    backup_and_link ~/.config/waybar "$DOTFILES/other/waybar"
  fi

  if command -v rofi &>/dev/null; then
    echo "Installing Rofi config..."
    backup_and_link ~/.config/rofi "$DOTFILES/other/rofi"
  fi
else
  echo "Skipping Hyprland configs (not installed)"
fi

echo ""
echo "✓ Dotfiles installed successfully!"
echo "✓ Backups saved to: $BACKUP_DIR"
echo "Restart your shell to apply changes."
