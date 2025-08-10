#!/usr/bin/env bash
set -e

FORCE=false
if [[ "$1" == "--force" ]]; then
    FORCE=true
fi

echo "=== Updating package list ==="
sudo apt update

install_if_missing() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo "[SKIP] $pkg is already installed"
    else
        echo "[INSTALL] Installing $pkg..."
        sudo apt install -y "$pkg"
    fi
}

echo "=== Installing required packages ==="
install_if_missing ffmpeg
install_if_missing jq
install_if_missing bat
install_if_missing gh
install_if_missing git
install_if_missing curl
install_if_missing zsh
install_if_missing zsh-syntax-highlighting
install_if_missing zsh-autosuggestions

if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    sudo update-alternatives --install /usr/local/bin/bat bat /usr/bin/batcat 1
fi

echo "=== Installing pnpm (if missing) ==="
if command -v pnpm &>/dev/null; then
    echo "[SKIP] pnpm is already installed"
else
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

echo "=== Installing nvm (if missing) ==="
if command -v nvm &>/dev/null || [[ -d "$HOME/.nvm" ]]; then
    echo "[SKIP] nvm is already installed"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

echo "=== Downloading config files from repo ==="
REPO_URL="https://raw.githubusercontent.com/huffmanks/config-stash/main/.dotfiles"

download_file() {
    local remote_filename="$1"
    local local_filename="${2:-$1}"
    local dest="$HOME/$local_filename"
    if [[ -f "$dest" && "$FORCE" == "false" ]]; then
        echo "[SKIP] $local_filename already exists (use --force to overwrite)"
    else
        echo "[DOWNLOAD] $remote_filename -> $local_filename"
        curl -fsSL "$REPO_URL/$remote_filename" -o "$dest"
    fi
}

download_file ".gitconfig"
download_file ".gitignore"
download_file "linux.zshrc" ".zshrc"

echo "=== Setting zsh as default shell ==="
if [[ "$SHELL" != "$(which zsh)" ]]; then
    if ! grep -q "$(which zsh)" /etc/shells; then
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi
    chsh -s "$(which zsh)"
    echo "[INFO] Default shell changed to zsh. Please log out and log back in."
else
    echo "[SKIP] zsh is already the default shell"
fi

echo "=== Setup complete! ==="
