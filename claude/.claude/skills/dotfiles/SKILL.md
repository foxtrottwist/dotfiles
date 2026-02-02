---
name: dotfiles
description: Manage GNU Stow-based dotfiles at ~/dotfiles. Use when user asks to stow/unstow packages, check dotfiles status, add new config packages, edit dotfiles, or mentions "/dotfiles". Handles symlink management for development environment configs (nvim, zsh, wezterm, zellij, mise).
---

# Dotfiles

Manage development environment configs via GNU Stow at `~/dotfiles`.

## Commands

Run `scripts/stow.sh` from skill directory:

```bash
./skills/dotfiles/scripts/stow.sh <command> [package]
```

| Command | Purpose |
|---------|---------|
| `status` | Show stow status for all packages |
| `stow <pkg>` | Create symlinks for a package |
| `unstow <pkg>` | Remove symlinks for a package |
| `restow <pkg>` | Refresh symlinks (unstow + stow) |
| `stow-all` | Stow all packages |
| `list` | List available packages |

## Package Structure

Each package mirrors home directory structure:

```
~/dotfiles/
├── nvim/
│   └── .config/
│       └── nvim/           → symlinked to ~/.config/nvim
├── zsh/
│   ├── .zshenv             → symlinked to ~/.zshenv
│   └── .zprofile           → symlinked to ~/.zprofile
└── wezterm/
    └── .wezterm.lua        → symlinked to ~/.wezterm.lua
```

## Adding a New Package

1. Create package directory: `mkdir -p ~/dotfiles/newpkg/.config/newpkg`
2. Add config files mirroring their home location
3. Stow: `./skills/dotfiles/scripts/stow.sh stow newpkg`
4. Commit: `cd ~/dotfiles && git add . && git commit -m "add newpkg"`

## Editing Configs

Edit files directly in `~/dotfiles/<package>/` - symlinks mean changes apply immediately.

After editing:
```bash
cd ~/dotfiles
git add . && git commit -m "update <package> config"
git push
```

## Sync with Monorepo

The dotfiles repo is also tracked at `external/dotfiles` in the Workflow Systems monorepo. After pushing changes from `~/dotfiles`, update the submodule reference:

```bash
cd /path/to/workflow-systems
git submodule update --remote external/dotfiles
git add external/dotfiles && git commit -m "update dotfiles"
```

Or use `/sync update` to update all submodules.
