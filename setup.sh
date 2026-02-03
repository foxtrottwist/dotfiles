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

# Download latest release asset from GitHub
# Usage: download_release_asset "owner/repo" "*.skill" "/output/dir"
download_release_asset() {
    local repo="$1"
    local pattern="$2"
    local output_dir="$3"

    # Get latest release assets via GitHub API
    local api_url="https://api.github.com/repos/$repo/releases/latest"
    local release_json=$(curl -sf "$api_url" 2>/dev/null) || return 1

    # Find asset matching pattern (convert glob to regex)
    local regex_pattern=$(echo "$pattern" | sed 's/\*/.*/g')
    local asset_url=$(echo "$release_json" | grep -o '"browser_download_url": *"[^"]*"' | \
        grep -E "$regex_pattern" | head -1 | sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/')

    [[ -z "$asset_url" ]] && return 1

    local filename=$(basename "$asset_url")
    curl -sfL "$asset_url" -o "$output_dir/$filename" 2>/dev/null || return 1
    echo "$output_dir/$filename"
}

# Fetch skills from GitHub releases
fetch_skills() {
    info "Fetching skills from GitHub releases..."

    local skills=(
        "foxtrottwist/iterative"
        "foxtrottwist/code-audit"
        "foxtrottwist/chat-migration"
        "foxtrottwist/dotfiles-skill"
        "foxtrottwist/prompt-dev"
        "foxtrottwist/submodule-sync"
        "foxtrottwist/write"
    )

    local tmp_dir=$(mktemp -d)
    local skills_dir="$HOME/.claude/skills"
    mkdir -p "$skills_dir"

    for repo in "${skills[@]}"; do
        local name=$(basename "$repo")
        # Normalize skill names to lowercase
        local skill_name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
        local skill_file=$(download_release_asset "$repo" "*.skill" "$tmp_dir")
        if [[ -f "$skill_file" ]]; then
            # Remove existing skill directory to avoid stow conflicts
            rm -rf "${skills_dir:?}/$skill_name" 2>/dev/null || true
            mkdir -p "$skills_dir/$skill_name"
            unzip -o -q "$skill_file" -d "$skills_dir/$skill_name"
            rm -f "$skill_file"
            success "Fetched skill: $skill_name"
        else
            warn "No release found: $name - using embedded if available"
        fi
    done

    rm -rf "$tmp_dir"
}

# Fetch MCP servers from GitHub releases
fetch_mcps() {
    info "Fetching MCP servers from GitHub releases..."

    local tmp_dir=$(mktemp -d)
    local mcp_dir="$HOME/.claude/mcps"
    mkdir -p "$mcp_dir"

    # shortcuts-mcp
    local mcpb_file=$(download_release_asset "foxtrottwist/shortcuts-mcp" "*.mcpb" "$tmp_dir")
    if [[ -f "$mcpb_file" ]]; then
        unzip -o -q "$mcpb_file" -d "$mcp_dir/shortcuts-mcp"
        success "Fetched MCP: shortcuts-mcp"

        # Add to Claude Code if not already configured
        if command -v claude &>/dev/null; then
            if ! grep -q "shortcuts-mcp" ~/.claude.json 2>/dev/null; then
                claude mcp add -s user --transport stdio shortcuts-mcp -- node "$mcp_dir/shortcuts-mcp/dist/server.js" 2>/dev/null || true
                success "Configured MCP: shortcuts-mcp"
            fi
        fi
    else
        warn "No release found: shortcuts-mcp"
    fi

    rm -rf "$tmp_dir"
}

# Clean up files that interfere with stow
cleanup() {
    info "Cleaning up..."

    # Remove .DS_Store files from dotfiles
    find "$DOTFILES_DIR" -name ".DS_Store" -delete 2>/dev/null

    # Remove .DS_Store from target locations
    rm -f "$HOME/.DS_Store" 2>/dev/null
    rm -f "$HOME/.claude/.DS_Store" 2>/dev/null
    rm -f "$HOME/.config/.DS_Store" 2>/dev/null

    success "Cleanup complete"
}

# Deploy dotfiles with stow
deploy_dotfiles() {
    info "Deploying dotfiles with stow..."
    cd "$DOTFILES_DIR"

    local packages=(claude ghostty mise nvim starship zellij zsh)

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

    # Check symlinks (skills not included - populated by fetch)
    local symlinks=(
        "$HOME/.claude/settings.json"
        "$HOME/.config/ghostty"
        "$HOME/.config/mise"
        "$HOME/.config/nvim"
        "$HOME/.config/starship.toml"
        "$HOME/.config/zellij"
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
    cleanup
    deploy_dotfiles
    fetch_skills
    fetch_mcps

    echo ""
    info "Running verification..."
    if verify_installation; then
        echo ""
        success "Setup complete!"
        echo ""
        info "Next steps:"
        echo "  1. Open Neovim - plugins will auto-install via lazy.nvim"
        echo "  2. Run :checkhealth in Neovim to verify LSP setup"
        echo "  3. Restart your shell or run: source ~/.zshrc"
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
        echo "  --update       Pull latest, restow, and fetch skills/MCPs"
        echo "  --cleanup      Remove .DS_Store and other interfering files"
        echo "  --verify       Only run verification checks"
        echo "  --stow-only    Only deploy dotfiles (skip package installation)"
        echo "  --fetch-only   Only fetch skills and MCPs from GitHub releases"
        echo ""
        ;;
    --update)
        info "Updating dotfiles..."
        cd "$DOTFILES_DIR"
        git pull
        cleanup
        deploy_dotfiles
        fetch_skills
        fetch_mcps
        success "Update complete!"
        ;;
    --cleanup)
        cleanup
        ;;
    --verify)
        verify_installation
        ;;
    --stow-only)
        deploy_dotfiles
        verify_installation
        ;;
    --fetch-only)
        fetch_skills
        fetch_mcps
        ;;
    *)
        main
        ;;
esac
