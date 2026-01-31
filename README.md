# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package   | Description                                       |
| --------- | ------------------------------------------------- |
| `nvim`    | Neovim configuration                              |
| `zsh`     | Zsh shell configuration (.zshrc, .zshenv, .zprofile) |
| `zellij`  | Zellij terminal multiplexer                       |
| `mise`    | Mise version manager                              |
| `wezterm` | WezTerm terminal emulator                         |

## Quick Start

Run the bootstrap script to install all dependencies and deploy configurations:

```bash
git clone git@github.com:foxtrottwist/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The script will:
- Install Homebrew (if not present)
- Install required packages (stow, neovim, ripgrep, fd, zellij, mise, zsh, wezterm)
- Install Oh My Zsh (if not present)
- Install Rust toolchain (if not present)
- Deploy all configurations via stow

## Manual Setup

If you prefer manual installation:

### Prerequisites

```bash
# Core tools
brew install stow neovim ripgrep fd zellij mise zsh

# WezTerm (macOS)
brew install --cask wezterm

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Rust (optional but recommended)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Installation

```bash
cd ~/dotfiles

# Deploy all configurations
stow nvim zsh zellij mise wezterm

# Or deploy individually
stow nvim
stow zsh
```

## Updating

After pulling changes, re-run stow to ensure symlinks are current:

```bash
cd ~/dotfiles
git pull
stow -R nvim zsh zellij mise wezterm
```

Or use the setup script:

```bash
./setup.sh --stow-only
```

## Verification

Check that everything is working:

```bash
./setup.sh --verify
```

## Adding New Configurations

```bash
# Create package structure
mkdir -p ~/dotfiles/[app]/.config/[app]

# Move existing config
mv ~/.config/[app]/* ~/dotfiles/[app]/.config/[app]/

# Deploy with stow
cd ~/dotfiles && stow [app]

# Commit
git add [app]
git commit -m "add [app] configuration"
```

For configs that live in `$HOME` (not `.config`):

```bash
mkdir -p ~/dotfiles/[app]
mv ~/.[app]rc ~/dotfiles/[app]/
cd ~/dotfiles && stow [app]
```

## Removing a Package

```bash
cd ~/dotfiles
stow -D [package]  # Removes symlinks
```

## Optional Tools

These tools are detected and configured automatically if present:

- **Miniconda** - Python environment manager (`~/miniconda3/`)
- **LM Studio CLI** - Local LLM tooling (`~/.lmstudio/`)
- **Rover** - Apollo GraphQL CLI (`~/.rover/`)

## Troubleshooting

### Stow conflicts

If stow reports conflicts, existing files may need to be removed or backed up:

```bash
# Check what exists
ls -la ~/.config/nvim

# Back up and retry
mv ~/.config/nvim ~/.config/nvim.bak
stow nvim
```

### Shell errors on startup

The zsh configuration includes existence checks for optional tools. If you see errors:

1. Run `./setup.sh --verify` to identify missing dependencies
2. Install missing tools or remove references from `.zshrc`
