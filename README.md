# Neovim Configuration

A stability-focused Neovim setup optimized for multi-language development workflows with robust LSP integration and error handling.

## Purpose

Built this configuration to solve recurring stability issues I was experiencing with my development environment. After dealing with plugin crashes and inconsistent LSP behavior, I needed a reliable setup that could handle my daily work across TypeScript, Python, Go, and Lua projects without constant troubleshooting.

## Tech Stack

**Core Framework:**
- Neovim 0.11+ - Modern LSP capabilities and improved performance
- Lazy.nvim - Fast, efficient plugin management
- Mason.nvim - Automated LSP server installation and management

**Language Support:**
- TypeScript/JavaScript - ts_ls with prettier formatting
- Python - Pyright + ruff for fast linting and formatting  
- Go - gopls with gofumpt integration
- Lua - lua_ls optimized for Neovim development
- Additional: CSS, HTML, GraphQL, Swift, Rust

**Productivity Tools:**
- Telescope - File search with ripgrep and fd integration
- Treesitter - Reliable syntax highlighting with error handling
- Oil.nvim - Directory navigation
- Harpoon - Quick file switching

<img src="https://raw.githubusercontent.com/foxtrottwist/foxtrottwist/main/assets/brider-codes.png" alt="Bridge Builder Fox mascot in helpful builder pose" width="64" height="64" align="right">

## Key Features

**Reliability:**
- Wrapped plugin setups in `pcall` for graceful failure handling
- Removed deprecated configurations that caused startup warnings
- Cleaned up orphaned LSP servers and unused dependencies

**Multi-Language Workflow:**
- Consistent LSP configuration across all supported languages
- Automatic formatting on save with language-specific rules
- Integrated linting that doesn't interrupt development flow

**Developer Experience:**
- Fast file searching with ripgrep and fd
- Git integration with line blame and change indicators
- Trouble.nvim for centralized diagnostic management
- Which-key for discoverable keybindings

## Setup

**Prerequisites:**
```bash
# Install external dependencies
brew install ripgrep fd neovim

# Ensure you have required language servers installed
# (Mason will handle most LSP installations automatically)
```

**Installation:**
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone [repository-url] ~/.config/nvim

# Launch Neovim - plugins will install automatically
nvim
```

## Configuration Highlights

**Error Prevention:**
- All LSP servers configured with consistent `capabilities` and `on_attach`
- Treesitter setup includes fallback handling for missing parsers
- Mason ensures LSP servers match configuration requirements

**Workflow Optimization:**
- Format-on-save configured for all supported languages
- Telescope keybindings optimized for quick project navigation
- Integrated terminal and file management for reduced context switching

**Health Monitoring:**
- Regular `:checkhealth` validation to catch configuration drift
- Proactive cleanup of unused plugins and language servers
- Version-locked plugins in `lazy-lock.json` for reproducible environments

## Personal Notes

This configuration evolved from frustration with unreliable development environments. The focus on stability over features means fewer plugins but more consistent daily productivity. Each language server configuration has been tested with real projects to ensure reliable completion, formatting, and error detection.

The error handling additions came from experiencing too many plugin crashes during important work sessions. Now when something breaks, Neovim continues functioning and provides clear notifications about what failed.
