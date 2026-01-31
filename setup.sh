#!/usr/bin/env bash
#
# Dotfiles bootstrap script
# Installs dependencies and deploys configurations via GNU Stow
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin) OS="macos" ;;
        Linux)  OS="linux" ;;
        *)      error "Unsupported operating system" ;;
    esac
    info "Detected OS: $OS"
}

# Install Homebrew (macOS/Linux)
install_homebrew() {
    if command -v brew &>/dev/null; then
        success "Homebrew already installed"
        return
    fi

    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for this session
    if [[ "$OS" == "macos" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    success "Homebrew installed"
}

# Install packages via Brewfile
install_brew_packages() {
    info "Installing packages from Brewfile..."

    if [[ "$OS" == "linux" ]]; then
        # Linux: skip casks, install only brew formulae
        brew bundle --file="$DOTFILES_DIR/Brewfile" --formula
    else
        # macOS: install everything including casks
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    fi

    success "Packages installed from Brewfile"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        success "Oh My Zsh already installed"
        return
    fi

    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh installed"
}

# Install Rust/Cargo
install_rust() {
    if command -v cargo &>/dev/null; then
        success "Rust/Cargo already installed"
        return
    fi

    info "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    success "Rust toolchain installed"
}

# Install LM Studio CLI (optional, requires manual download of app first)
check_lm_studio() {
    if [[ -d "$HOME/.lmstudio" ]]; then
        success "LM Studio CLI detected"
    else
        warn "LM Studio CLI not found - install LM Studio app to enable CLI"
    fi
}

# Deploy dotfiles with stow
deploy_dotfiles() {
    info "Deploying dotfiles with stow..."
    cd "$DOTFILES_DIR"

    local packages=(nvim zsh zellij mise ghostty starship)

    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            # Remove existing symlinks first to avoid conflicts
            stow -D "$pkg" 2>/dev/null || true
            stow "$pkg"
            success "Deployed $pkg"
        else
            warn "Package $pkg not found, skipping"
        fi
    done
}

# Verify installation
verify_installation() {
    info "Verifying installation..."
    local failed=0

    for cmd in nvim zellij mise stow rg fd starship; do
        if command -v "$cmd" &>/dev/null; then
            success "$cmd: $(command -v "$cmd")"
        else
            warn "$cmd not found"
            failed=1
        fi
    done

    # Check symlinks
    local symlinks=(
        "$HOME/.config/nvim"
        "$HOME/.config/zellij"
        "$HOME/.config/mise"
        "$HOME/.config/ghostty"
        "$HOME/.config/starship.toml"
        "$HOME/.zshrc"
    )

    for link in "${symlinks[@]}"; do
        if [[ -L "$link" ]] || [[ -e "$link" ]]; then
            success "Symlink exists: $link"
        else
            warn "Missing: $link"
            failed=1
        fi
    done

    return $failed
}

# Main
main() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║       Dotfiles Bootstrap Script        ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    detect_os
    install_homebrew
    install_brew_packages
    install_oh_my_zsh
    install_rust
    check_lm_studio
    deploy_dotfiles

    echo ""
    info "Running verification..."
    if verify_installation; then
        echo ""
        success "Setup complete!"
        echo ""
        info "Next steps:"
        echo "  1. Restart your terminal or run: source ~/.zshrc"
        echo "  2. Open Neovim - plugins will auto-install via lazy.nvim"
        echo "  3. Run :checkhealth in Neovim to verify LSP setup"
        echo ""
    else
        echo ""
        warn "Setup completed with warnings - check output above"
    fi
}

# Run with optional flags
case "${1:-}" in
    --help|-h)
        echo "Usage: ./setup.sh [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --verify       Only run verification checks"
        echo "  --stow-only    Only deploy dotfiles (skip package installation)"
        echo ""
        ;;
    --verify)
        verify_installation
        ;;
    --stow-only)
        deploy_dotfiles
        verify_installation
        ;;
    *)
        main
        ;;
esac
