---
name: dotfiles
description: Manage GNU Stow-based dotfiles at ~/dotfiles. Use when user asks to stow/unstow packages, check dotfiles status, add new config packages, fetch skills/MCPs, edit dotfiles, or mentions "/dotfiles". Handles symlink management for configs (claude, ghostty, mise, nvim, starship, zellij, zsh).
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
├── claude/
│   └── .claude/
│       ├── settings.json   → symlinked to ~/.claude/settings.json
│       └── skills/         → symlinked to ~/.claude/skills
├── nvim/
│   └── .config/
│       └── nvim/           → symlinked to ~/.config/nvim
└── zsh/
    ├── .zshenv             → symlinked to ~/.zshenv
    └── .zprofile           → symlinked to ~/.zprofile
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

## Fetching Skills and MCPs

Skills and MCP servers are fetched via the dotfiles repo's setup script (not this skill). This keeps bootstrap self-contained.

```bash
cd ~/dotfiles
./setup.sh --fetch-only
```

Skills without releases use embedded versions. As repos add release workflows, fetch automatically picks them up.
