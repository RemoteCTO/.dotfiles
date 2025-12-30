# Dotfiles

Personal shell configuration for macOS with zsh.

## Quick Start

```bash
# One-liner bootstrap (on fresh Mac)
curl -fsSL https://raw.githubusercontent.com/RemoteCTO/.dotfiles/main/install.sh | bash

# Or clone and run manually
git clone https://github.com/RemoteCTO/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

## What's Included

- **Zsh** configuration with Oh My Zsh (robbyrussell theme)
- **Homebrew** package management
- **Version managers**: rbenv, pyenv, nvm, Cargo/Rust

## File Structure

```
~/.dotfiles/
├── install.sh          # Idempotent bootstrap script
├── Brewfile            # Homebrew packages
├── zsh/                # Zsh configuration
│   ├── zshrc           # Main config -> ~/.zshrc
│   ├── zshenv          # Environment -> ~/.zshenv
│   ├── zprofile        # Login shell -> ~/.zprofile
│   ├── aliases.zsh     # Shell aliases
│   ├── path.zsh        # PATH management
│   └── tools/          # Tool-specific configs
```

## Secrets

Machine-specific secrets go in `~/.zshrc.local` (not committed):

```bash
# Create from template
cp ~/.dotfiles/.zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
# Edit with your values
```

## Post-Install

```bash
# Ruby
rbenv install 3.3.0 && rbenv global 3.3.0

# Python
pyenv install 3.12 && pyenv global 3.12

# Node
nvm install --lts && nvm use --lts

# Git (configure manually)
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## Updating

```bash
cd ~/.dotfiles && git pull
source ~/.zshrc
```
