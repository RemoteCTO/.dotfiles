#!/bin/bash
set -euo pipefail

# ============================================================================
# Dotfiles Bootstrap Script
# Idempotent - safe to run multiple times
# ============================================================================

DOTFILES="$HOME/.dotfiles"
REPO="https://github.com/RemoteCTO/.dotfiles.git"

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Colour

info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ============================================================================
# Pre-flight checks
# ============================================================================
check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This script is for macOS only"
    fi
    info "Running on macOS $(sw_vers -productVersion)"
}

# ============================================================================
# Xcode Command Line Tools
# ============================================================================
install_xcode_cli() {
    if xcode-select -p &>/dev/null; then
        info "Xcode CLI tools already installed"
    else
        info "Installing Xcode CLI tools..."
        xcode-select --install
        # Wait for installation
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
        info "Xcode CLI tools installed"
    fi
}

# ============================================================================
# Homebrew
# ============================================================================
install_homebrew() {
    if command -v brew &>/dev/null; then
        info "Homebrew already installed"
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL \
            https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_brew_packages() {
    if [[ -f "$DOTFILES/Brewfile" ]]; then
        info "Installing Homebrew packages from Brewfile..."
        brew bundle --file="$DOTFILES/Brewfile"
    else
        warn "No Brewfile found, skipping"
    fi
}

# ============================================================================
# Clone/Update Dotfiles
# ============================================================================
setup_dotfiles() {
    if [[ -d "$DOTFILES/.git" ]]; then
        info "Dotfiles repo exists, pulling latest..."
        git -C "$DOTFILES" pull --rebase
    else
        info "Cloning dotfiles..."
        # Backup existing if present
        if [[ -d "$DOTFILES" ]]; then
            warn "Moving old ~/.dotfiles to ~/.dotfiles.backup"
            mv "$DOTFILES" "$HOME/.dotfiles.backup.$(date +%s)"
        fi
        git clone "$REPO" "$DOTFILES"
    fi
}

# ============================================================================
# Symlinks
# ============================================================================
create_symlink() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        # Already a symlink - check if pointing to right place
        if [[ "$(readlink "$dest")" == "$src" ]]; then
            info "Symlink exists: $dest"
            return
        fi
        warn "Updating symlink: $dest"
        rm "$dest"
    elif [[ -f "$dest" ]]; then
        warn "Backing up existing: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    ln -s "$src" "$dest"
    info "Created symlink: $dest -> $src"
}

setup_symlinks() {
    info "Creating symlinks..."

    # Zsh files
    create_symlink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES/zsh/zprofile" "$HOME/.zprofile"
    create_symlink "$DOTFILES/zsh/zshenv" "$HOME/.zshenv"
}

# ============================================================================
# Oh My Zsh
# ============================================================================
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        info "Oh My Zsh already installed"
    else
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL \
            https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended --keep-zshrc
    fi
}

# ============================================================================
# Version Managers
# ============================================================================
install_rbenv() {
    if command -v rbenv &>/dev/null; then
        info "rbenv already installed"
    else
        info "Installing rbenv via Homebrew..."
        brew install rbenv ruby-build
    fi
}

install_pyenv() {
    if command -v pyenv &>/dev/null; then
        info "pyenv already installed"
    else
        info "Installing pyenv via Homebrew..."
        brew install pyenv
    fi
}

install_nvm() {
    if [[ -d "$HOME/.nvm" ]] || [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
        info "nvm already installed"
    else
        info "Installing nvm via Homebrew..."
        brew install nvm
        mkdir -p "$HOME/.nvm"
    fi
}

install_rust() {
    if command -v rustup &>/dev/null; then
        info "Rust already installed"
    else
        info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
}

# ============================================================================
# Secrets Setup
# ============================================================================
setup_secrets() {
    local secrets_file="$HOME/.zshrc.local"

    if [[ -f "$secrets_file" ]]; then
        info "Secrets file exists: $secrets_file"
    else
        warn "Creating secrets file template: $secrets_file"
        cat > "$secrets_file" << 'EOF'
# Machine-specific secrets - NOT committed to git
# Add your API keys and secrets here

# export LINEAR_API_KEY="lin_api_..."
# export KAMAL_ACCOUNT="..."

EOF
        chmod 600 "$secrets_file"
        warn "IMPORTANT: Edit ~/.zshrc.local to add your secrets"
    fi
}

# ============================================================================
# Main
# ============================================================================
main() {
    echo ""
    echo "=================================================="
    echo "  Dotfiles Bootstrap"
    echo "=================================================="
    echo ""

    check_macos
    install_xcode_cli
    install_homebrew
    setup_dotfiles
    install_brew_packages
    install_oh_my_zsh
    install_rbenv
    install_pyenv
    install_nvm
    install_rust
    setup_symlinks
    setup_secrets

    echo ""
    echo "=================================================="
    echo "  Bootstrap Complete!"
    echo "=================================================="
    echo ""
    info "Next steps:"
    echo "  1. Edit ~/.zshrc.local to add your secrets"
    echo "  2. Restart your terminal or run: source ~/.zshrc"
    echo "  3. Install Ruby: rbenv install 3.3.0 && rbenv global 3.3.0"
    echo "  4. Install Python: pyenv install 3.12 && pyenv global 3.12"
    echo "  5. Install Node: nvm install --lts && nvm use --lts"
    echo "  6. Configure git: git config --global user.name/email"
    echo ""
}

main "$@"
