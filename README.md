# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Description |
|---------|-------------|
| `nvim` | Neovim configuration |
| `zsh` | Zsh shell configuration (.zshrc, .zshenv, .zprofile) |
| `zellij` | Zellij terminal multiplexer |
| `mise` | Mise version manager |
| `wezterm` | WezTerm terminal emulator (empty, ready for config) |

## Setup

### Prerequisites

```bash
brew install stow neovim ripgrep fd
```

### Installation

```bash
# Clone the repository
git clone git@github.com:foxtrottwist/dotfiles.git ~/dotfiles

# Navigate to dotfiles directory
cd ~/dotfiles

# Deploy all configurations
stow nvim zsh zellij mise

# Or deploy individually
stow nvim
stow zsh
```

### Updating

After pulling changes, re-run stow to ensure symlinks are current:

```bash
cd ~/dotfiles
git pull
stow -R nvim zsh zellij mise
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
