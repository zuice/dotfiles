# Dotfiles

Personal configuration files for development tools.

## Setup on a new computer

1. Clone the repo:
   ```bash
   git clone <your-repo-url> ~/dev/dotfiles
   cd ~/dev/dotfiles
   ```

2. Run setup (installs fonts and other dependencies):
   ```bash
   ./setup.sh
   ```

3. Install dotfiles (backs up existing configs and creates symlinks):
   ```bash
   ./install.sh
   ```

4. Restart your shell

## Workflow

**On your desktop (or any computer):**

1. Edit configs normally: `~/.config/nvim`, `~/.zshrc`, etc.
2. Changes sync automatically to `~/dev/dotfiles` (via symlinks)
3. Commit changes:
   ```bash
   cd ~/dev/dotfiles
   git add .
   git commit -m "your message"
   git push
   ```

**On other computers:**

```bash
cd ~/dev/dotfiles
git pull
./install.sh
```

## Structure

```
dotfiles/
├── zsh/              # Zsh shell configuration
├── nvim/             # Neovim configuration
├── git/              # Git configuration
└── other/            # Other tool configs
    ├── ghostty/      # Ghostty terminal config
├── install.sh        # Creates symlinks (backs up existing configs)
└── setup.sh          # Installs fonts and dependencies
```
