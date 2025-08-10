#!/usr/bin/env bash
set -e

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <macos|linux>"
    exit 1
fi

OS_TYPE="$1"
REPO_URL="https://raw.githubusercontent.com/huffmanks/config-stash/main/.dotfiles"

copy_file() {
    local remote_filename="$1"
    local local_filename="${2:-$1}"
    echo "[COPY] $remote_filename -> $HOME/$local_filename"
    curl -fsSL "$REPO_URL/$remote_filename" -o "$HOME/$local_filename"
}

case "$OS_TYPE" in
    macos)
        copy_file ".gitconfig"
        copy_file ".gitignore"
        copy_file ".zprofile"
        copy_file "macos.zshrc" ".zshrc"
        ;;
    linux)
        copy_file ".gitconfig"
        copy_file ".gitignore"
        copy_file "linux.zshrc" ".zshrc"
        ;;
    *)
        echo "Invalid option: $OS_TYPE"
        echo "Usage: $0 <macos|linux>"
        exit 1
        ;;
esac

echo "=== Dotfiles copied for $OS_TYPE ==="
