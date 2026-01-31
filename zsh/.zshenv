# .zshenv - Loaded for all shell types (interactive, non-interactive, login, etc.)
# Keep this file minimal - only environment variables needed everywhere

# Rover - Apollo GraphQL CLI (optional)
[[ -f "$HOME/.rover/env" ]] && source "$HOME/.rover/env"

# Cargo/Rust toolchain (optional)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
