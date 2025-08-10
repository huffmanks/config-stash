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
install_if_missing bat
install_if_missing gh
install_if_missing git
install_if_missing curl
install_if_missing zsh

if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    sudo update-alternatives --install /usr/local/bin/bat bat /usr/bin/batcat 1
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
download_file "android.zshrc" ".zshrc"

echo "=== Installing zsh-autosuggestions from GitHub ==="
ZSH_AUTOSUGGESTIONS_DIR="$HOME/.zsh/zsh-autosuggestions"
if [[ -d "$ZSH_AUTOSUGGESTIONS_DIR" ]]; then
    echo "[SKIP] zsh-autosuggestions already cloned at $ZSH_AUTOSUGGESTIONS_DIR"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGESTIONS_DIR"
fi

echo "=== Installing zsh-syntax-highlighting from GitHub ==="
ZSH_SYNTAX_HIGHLIGHTING_DIR="$HOME/.zsh/zsh-syntax-highlighting"
if [[ -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]]; then
    echo "[SKIP] zsh-syntax-highlighting already cloned at $ZSH_SYNTAX_HIGHLIGHTING_DIR"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
fi

ZSHRC_TEST="$HOME/.zshrc"
if zsh -n "$ZSHRC_TEST"; then
    echo "[OK] .zshrc syntax looks good."
else
    echo "[ERROR] .zshrc has syntax errors. Aborting shell switch."
    exit 1
fi

echo "=== Testing .zshrc runtime (zsh -x) ==="
if zsh -x -c "source $ZSHRC_TEST" >/dev/null 2>&1; then
    echo "[OK] .zshrc runs without errors."
else
    echo "[ERROR] .zshrc runtime error detected. Aborting shell switch."
    exit 1
fi

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
