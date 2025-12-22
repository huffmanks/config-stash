#!/usr/bin/env bash
set -e

REPO_URL="https://raw.githubusercontent.com/huffmanks/config-stash/main/.dotfiles"
ZSHRC_LOCAL="$HOME/.zshrc.test"

# Detect OS and Architecture
OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH_NAME=$(uname -m)
HOST_NAME=$(hostname -s)

if [[ "$OS_NAME" == "darwin" ]]; then
    OS_TYPE="macos"
    [[ "$ARCH_NAME" == "arm64" ]] && ARCH_TYPE="arm" || ARCH_TYPE="intel"
elif [[ "$OS_NAME" == "linux" ]]; then
    OS_TYPE="linux"
    [[ "$ARCH_NAME" == "aarch64" || "$ARCH_NAME" == "arm64" ]] && ARCH_TYPE="arm" || ARCH_TYPE="intel"
else
    echo "Unsupported OS: $OS_NAME"
    exit 1
fi

echo "----- Getting .dotfiles for ($HOST_NAME:$OS_TYPE:$ARCH_NAME) -----"

# Parse export flags
ALL_EXPORTS=false
SELECTED_EXPORTS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --all-exports) ALL_EXPORTS=true; shift ;;
        --*) SELECTED_EXPORTS+=("${1#--}"); shift ;;
        *) shift ;;
    esac
done

# Helper: Print remote file content to stdout
get_content() {
    local url="$REPO_URL/$1"
    local content
    content=$(curl -fsSL "$url" 2>/dev/null)

    if [[ -n "$content" ]]; then
        echo "$content"
        echo -e "\n"
    fi
}

# Helper: Copy standalone file only if it exists in repo
fetch_to_file() {
    local remote_path="$1"
    local local_path="$2"

    if curl -fsSL -I "$REPO_URL/$remote_path" >/dev/null 2>&1; then
        echo "[COPY] $remote_path > $local_path"
        curl -fsSL "$REPO_URL/$remote_path" -o "$local_path"
    fi
}

# Copy standalone dotfiles
echo "[COPY] .gitconfig > $HOME/.gitconfig"
fetch_to_file ".gitconfig" "$HOME/.gitconfig"

echo "[COPY] .gitignore > $HOME/.gitignore"
fetch_to_file ".gitignore" "$HOME/.gitignore"

echo "[COPY] .zprofile > $HOME/.zprofile"
fetch_to_file ".zsh/$OS_TYPE/$ARCH_TYPE/.zprofile" "$HOME/.zprofile"

# Generate .zshrc
echo "[BUILD] Generating .zshrc > $HOME/.zshrc"

{
    # 1. Config
    get_content ".zsh/common/config.zsh"

    # 2. Exports
    AVAILABLE_EXPORTS=("bun" "docker" "go" "java-android-studio" "nvm" "pipx" "pnpm")

    for tool in "${AVAILABLE_EXPORTS[@]}"; do
        echo "# ====================================="
        echo "# Exports"
        echo "# ====================================="
        echo -e "\n"
        if [[ "$ALL_EXPORTS" == true ]] || [[ " ${SELECTED_EXPORTS[*]} " =~ " ${tool} " ]]; then
            if [[ "$tool" == "pnpm" ]]; then
                # pnpm is OS-specific
                get_content ".zsh/$OS_TYPE/exports/pnpm.zsh"
            else
                # Others are common
                get_content ".zsh/common/exports/$tool.zsh"
            fi
        fi
    done

    # 3. Prompt
    get_content ".zsh/common/prompt.zsh"

    # 4. Aliases
    get_content ".zsh/common/aliases.zsh"
    # --- OS specific aliases
    get_content ".zsh/$OS_TYPE/aliases.zsh"

    # 5. Plugins
    # --- OS specific plugins
    get_content ".zsh/$OS_TYPE/plugins.zsh"
    # --- Architecture specific plugins
    get_content ".zsh/$OS_TYPE/$ARCH_TYPE/plugins.zsh"

} > "$ZSHRC_LOCAL"

echo "===== Setup Complete ====="