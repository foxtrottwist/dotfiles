# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

GNU Stow-based dotfiles repo for macOS. Each top-level directory is a stow package that mirrors the target file structure relative to `$HOME`. Stow creates symlinks from `$HOME` back into this repo.

## Commands

```bash
# Bootstrap everything (Homebrew, packages, Oh My Zsh, Rust, stow, skills)
./setup.sh

# Deploy all stow packages (skip installs)
./setup.sh --stow-only

# Pull latest, restow, fetch skills
./setup.sh --update

# Fetch standalone skills only
./setup.sh --fetch-only

# Check symlinks and tool availability
./setup.sh --verify

# Deploy a single package
cd ~/dotfiles && stow <package>

# Remove a package's symlinks
cd ~/dotfiles && stow -D <package>

# Restow (remove + re-link) after changes
cd ~/dotfiles && stow -R <package>
```

## Architecture

**Stow packages** — each directory maps to `$HOME`:
- `claude/` — `.claude/settings.json` and `.claude/CLAUDE.md` (global Claude Code config)
- `git/` — `.config/git/config` and `.config/git/ignore` (global git config + gitignore via XDG path; `config.local` for per-machine user settings)
- `ghostty/` — `.config/ghostty/`
- `mise/` — `.config/mise/config.toml`
- `nvim/` — `.config/nvim/` (lazy.nvim, plugin configs under `lua/foxtrottwist/`)
- `starship/` — `.config/starship.toml`
- `zellij/` — `.config/zellij/`
- `zsh/` — `.zshrc`, `.zshenv`, `.zprofile`

**Stow convention**: A file at `nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua`. Files directly in a package root (like `zsh/.zshrc`) become `~/.zshrc`.

**setup.sh** — Idempotent bootstrap script. Installs Homebrew, Brewfile packages, Oh My Zsh, Rust, then stows all packages and fetches standalone skills from GitHub releases. Each `--flag` runs only that subset.

**Skills** — Two standalone `.skill` archives (dotfiles-skill, submodule-sync) are fetched from GitHub releases and unpacked to `~/.claude/skills/`. Other skills are bundled in the `workflow-tools` Claude Code plugin.

**`.stow-local-ignore`** — Both the repo root and `claude/` package have these to exclude `.DS_Store` from stow operations.

## Key Details

- The `claude/` package stows the *global* `~/.claude/CLAUDE.md` and `~/.claude/settings.json` — edits there affect all projects
- Zsh auto-attaches to a Zellij session named "main" on shell startup
- Optional tools (Miniconda, LM Studio CLI, Rover) are conditionally loaded via existence checks in `.zshrc`/`.zshenv`
- Neovim uses lazy.nvim with plugins organized under `nvim/.config/nvim/lua/foxtrottwist/plugins/`
- `.gitignore` excludes `*.skill`, `*.local`, `*.local.*`, `.claude/` (repo-local settings), and `.code-audit/`
