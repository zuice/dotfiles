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

install_packages() {
  if [ ! -f /etc/arch-release ]; then
    echo "Auto-install only supported on Arch Linux. Install packages manually."
    return 1
  fi

  local pkgs=()

  for pkg in $1; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      pkgs+=("$pkg")
    fi
  done

  if [ ${#pkgs[@]} -gt 0 ]; then
    echo "Installing packages: ${pkgs[*]}"
    sudo pacman -S --noconfirm --needed "${pkgs[@]}"
  fi
}

# ── Shared packages ──
SHARED_PKGS="starship neovim git"

echo ""
echo "Checking shared packages..."
install_packages "$SHARED_PKGS"

# ── Link shared configs ──
echo ""
echo "Installing Zsh configs..."
backup_and_link ~/.zshrc "$DOTFILES/zsh/.zshrc"

echo "Installing Starship config..."
backup_and_link ~/.config/starship.toml "$DOTFILES/other/starship/starship.toml"

echo "Installing Neovim config..."
backup_and_link ~/.config/nvim "$DOTFILES/nvim"

echo "Installing Git configs..."
backup_and_link ~/.gitconfig "$DOTFILES/git/.gitconfig"
backup_and_link ~/.config/git/ignore "$DOTFILES/git/ignore"

# ── Ghostty ──
if command -v ghostty &>/dev/null; then
  echo "Installing Ghostty config..."
  backup_and_link ~/.config/ghostty/config "$DOTFILES/other/ghostty/config"
else
  echo "Skipping Ghostty config (not installed)"
fi

# ── Hyprland ──
HYPRLAND_PKGS="hyprland hyprlock hypridle waybar rofi swaybg swaync wl-clipboard cliphist polkit-kde-agent blueman udiskie brightnessctl playerctl wireplumber grim slurp ttf-firacode-nerd"

echo ""
if command -v Hyprland &>/dev/null; then
  HAS_HYPRLAND=true
else
  read -p "Install Hyprland and related packages? [y/N] " install_hypr
  if [[ $install_hypr =~ ^[Yy]$ ]]; then
    HAS_HYPRLAND=true
  else
    HAS_HYPRLAND=false
    echo "Skipping Hyprland configs"
  fi
fi

if [ "$HAS_HYPRLAND" = true ]; then
  echo "Checking Hyprland packages..."
  install_packages "$HYPRLAND_PKGS"

  echo ""
  echo "Installing Hyprland configs..."
  backup_and_link ~/.config/hypr/hyprland.conf "$DOTFILES/other/hypr/hyprland.conf"
  backup_and_link ~/.config/hypr/hyprlock.conf "$DOTFILES/other/hypr/hyprlock.conf"
  backup_and_link ~/.config/hypr/hypridle.conf "$DOTFILES/other/hypr/hypridle.conf"
  backup_and_link ~/.config/hypr/assets "$DOTFILES/other/hypr/assets"
  backup_and_link ~/.config/waybar "$DOTFILES/other/waybar"
  backup_and_link ~/.config/rofi "$DOTFILES/other/rofi"
fi

echo ""
echo "✓ Dotfiles installed successfully!"
echo "✓ Backups saved to: $BACKUP_DIR"
echo "Restart your shell to apply changes."
