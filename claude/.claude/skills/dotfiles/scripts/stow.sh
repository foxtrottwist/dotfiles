#!/bin/bash
# Dotfiles stow management script

set -e

DOTFILES_DIR="$HOME/dotfiles"

usage() {
    echo "Usage: $0 <command> [package]"
    echo ""
    echo "Commands:"
    echo "  status          Show stow status for all packages"
    echo "  stow <pkg>      Stow a package (create symlinks)"
    echo "  unstow <pkg>    Unstow a package (remove symlinks)"
    echo "  restow <pkg>    Restow a package (unstow then stow)"
    echo "  stow-all        Stow all packages"
    echo "  list            List available packages"
    exit 1
}

list_packages() {
    cd "$DOTFILES_DIR"
    for pkg in */; do
        echo "${pkg%/}"
    done
}

check_stowed() {
    local pkg="$1"
    local pkg_dir="$DOTFILES_DIR/$pkg"
    local stowed=true

    # Check each file/dir in package
    while IFS= read -r -d '' file; do
        rel="${file#$pkg_dir/}"
        target="$HOME/$rel"

        if [ -L "$target" ]; then
            link_target=$(readlink "$target")
            expected="../dotfiles/$pkg/$rel"
            if [[ "$link_target" != *"dotfiles/$pkg"* ]]; then
                stowed=false
                break
            fi
        elif [ -e "$target" ]; then
            # File exists but not a symlink - conflict
            stowed=false
            break
        else
            stowed=false
            break
        fi
    done < <(find "$pkg_dir" -type f -print0 2>/dev/null)

    echo "$stowed"
}

status_all() {
    echo "=== Dotfiles Status ==="
    echo "Location: $DOTFILES_DIR"
    echo ""

    cd "$DOTFILES_DIR"
    for pkg in */; do
        pkg="${pkg%/}"

        # Count files in package
        file_count=$(find "$DOTFILES_DIR/$pkg" -type f | wc -l | tr -d ' ')

        # Simple check: look for expected symlinks
        if [ "$(check_stowed "$pkg")" = "true" ]; then
            status="[stowed]"
        else
            status="[not stowed]"
        fi

        printf "%-15s %s (%s files)\n" "$pkg" "$status" "$file_count"
    done
}

stow_pkg() {
    local pkg="$1"
    if [ -z "$pkg" ]; then
        echo "Error: package name required"
        exit 1
    fi

    if [ ! -d "$DOTFILES_DIR/$pkg" ]; then
        echo "Error: package '$pkg' not found in $DOTFILES_DIR"
        exit 1
    fi

    cd "$DOTFILES_DIR"
    stow "$pkg"
    echo "Stowed: $pkg"
}

unstow_pkg() {
    local pkg="$1"
    if [ -z "$pkg" ]; then
        echo "Error: package name required"
        exit 1
    fi

    cd "$DOTFILES_DIR"
    stow -D "$pkg"
    echo "Unstowed: $pkg"
}

restow_pkg() {
    local pkg="$1"
    if [ -z "$pkg" ]; then
        echo "Error: package name required"
        exit 1
    fi

    cd "$DOTFILES_DIR"
    stow -R "$pkg"
    echo "Restowed: $pkg"
}

stow_all() {
    cd "$DOTFILES_DIR"
    for pkg in */; do
        pkg="${pkg%/}"
        stow "$pkg"
        echo "Stowed: $pkg"
    done
}

case "${1:-}" in
    status) status_all ;;
    stow) stow_pkg "$2" ;;
    unstow) unstow_pkg "$2" ;;
    restow) restow_pkg "$2" ;;
    stow-all) stow_all ;;
    list) list_packages ;;
    *) usage ;;
esac
