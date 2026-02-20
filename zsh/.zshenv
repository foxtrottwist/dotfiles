# .zshenv - Loaded for all shell types (interactive, non-interactive, login, etc.)
# Keep this file minimal - only environment variables needed everywhere

# Ensure TERM is set (fallback for Zellij session re-attach/resurrection)
export TERM="${TERM:-xterm-256color}"

# Rover - Apollo GraphQL CLI (optional)
[[ -f "$HOME/.rover/env" ]] && source "$HOME/.rover/env"

# Cargo/Rust toolchain (optional)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Machine-local overrides (not tracked in dotfiles)
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
