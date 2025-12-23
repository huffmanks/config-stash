#!/usr/bin/env bash
set -e

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <linux|android> [optional dotfile flags]"
    exit 1
fi

OS_TYPE="$1"
shift
DOTFILE_ARGS="$@"

# Helper: Install missing packages
install_if_missing() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo "[SKIP] $pkg is already installed"
    else
        echo "[INSTALL] Installing $pkg..."
        sudo apt install -y "$pkg"
    fi
}

# 1. Update package manager
echo "=== Updating package list ==="
sudo apt update

# 2. Installing packages
echo "=== Installing required packages ==="
install_if_missing bat
install_if_missing gh
install_if_missing git
install_if_missing zsh

# --- bat vs batcat
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    sudo update-alternatives --install /usr/local/bin/bat bat /usr/bin/batcat 1
fi

# 3. Generate .zshrc and copy .gitconfig, .gitignore and .zprofile
echo "=== Calling dotfile generator ==="
bash <(curl -fsSL https://raw.githubusercontent.com/huffmanks/config-stash/main/scripts/get-dotfiles.sh) $DOTFILE_ARGS

# 4. OS-specific installs
case "$OS_TYPE" in
    android)
        echo "=== Installing zsh plugins ==="
        mkdir -p "$HOME/.zsh"

        # --- zsh-autosuggestions
        if [[ -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
            echo "[SKIP] zsh-autosuggestions already installed"
        else
            git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.zsh/zsh-autosuggestions"
        fi

        # --- zsh-syntax-highlighting
        if [[ -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
            echo "[SKIP] zsh-syntax-highlighting already installed"
        else
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"
        fi

        # Test/validate .zshrc (Android)
        ZSHRC_TEST="$HOME/.zshrc"
        if zsh -n "$ZSHRC_TEST"; then
            echo "[OK] .zshrc syntax looks good"
        else
            echo "[ERROR] .zshrc has syntax errors. (Aborting shell switch)"
            exit 1
        fi

        echo "=== Testing .zshrc runtime (zsh -x) ==="
        if zsh -x -c "source $ZSHRC_TEST" >/dev/null 2>&1; then
            echo "[OK] .zshrc runs without errors"
        else
            echo "[ERROR] .zshrc runtime error detected. (Aborting shell switch)"
            exit 1
        fi

        # Change shell to zsh (Android)
        echo "=== Setting zsh as default shell ==="
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            if ! grep -q "$(which zsh)" /etc/shells; then
                echo "$(which zsh)" | sudo tee -a /etc/shells
            fi
            chsh -s "$(which zsh)"
            echo "[INFO] Default shell changed to zsh"
        else
            echo "[SKIP] zsh is already the default shell"
        fi
        ;;
    linux)
        install_if_missing ffmpeg
        install_if_missing jq
        install_if_missing zsh-syntax-highlighting
        install_if_missing zsh-autosuggestions

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

        # Change shell to zsh (Linux)
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
        ;;
    *)
        echo "Invalid option: $OS_TYPE"
        echo "Usage: $0 <linux|android>"
        exit 1
        ;;
esac

echo "=== Setup complete! ==="