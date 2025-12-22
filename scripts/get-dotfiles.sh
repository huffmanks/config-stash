#!/usr/bin/env bash
set -e

REPO_URL="https://raw.githubusercontent.com/huffmanks/config-stash/main/.dotfiles"
ZSHRC_LOCAL="$HOME/.zshrc.test"

# 1. Detect OS and Architecture
OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH_NAME=$(uname -m)

if [[ "$OS_NAME" == "darwin" ]]; then
    OS_TYPE="macos"
    [[ "$ARCH_NAME" == "arm64" ]] && ARCH_TYPE="arm" || ARCH_TYPE="intel"
elif [[ "$OS_NAME" == "linux" ]]; then
    OS_TYPE="linux"
    ARCH_TYPE="x86"
else
    echo "Unsupported OS: $OS_NAME"
    exit 1
fi

echo "--- Building Dotfiles for: $OS_TYPE ($ARCH_TYPE) ---"

# 2. Parse Export Flags
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
    curl -fsSL "$REPO_URL/$1" || echo "# [Error: Could not fetch $1]"
}

# 3. Copy Standalone Dotfiles
echo "[COPY] .gitconfig & .gitignore"
curl -fsSL "$REPO_URL/.gitconfig" -o "$HOME/.gitconfig"
curl -fsSL "$REPO_URL/.gitignore" -o "$HOME/.gitignore"

if [[ "$OS_TYPE" == "macos" ]]; then
    echo "[COPY] .zprofile ($ARCH_TYPE)"
    curl -fsSL "$REPO_URL/.zsh/macos/$ARCH_TYPE/.zprofile" -o "$HOME/.zprofile"
fi

# 4. Generate the Monolithic .zshrc
echo "[BUILD] Generating $ZSHRC_LOCAL"

{
    echo "### AUTO-GENERATED ZSHRC - DO NOT EDIT MANUALLY ###"
    echo "# Environment: $OS_TYPE $ARCH_TYPE"
    echo ""

    echo "# --- COMMON CONFIG ---"
    get_content ".zsh/common/config.zsh"
    get_content ".zsh/common/prompt.zsh"
    get_content ".zsh/common/aliases.zsh"

    echo -e "\n# --- OS SPECIFIC ($OS_TYPE) ---"
    get_content ".zsh/$OS_TYPE/aliases.zsh"
    get_content ".zsh/$OS_TYPE/plugins.zsh"

    if [[ "$OS_TYPE" == "macos" ]]; then
        echo -e "\n# --- MAC ARCH SPECIFIC ($ARCH_TYPE) ---"
        get_content ".zsh/macos/$ARCH_TYPE/plugins.zsh"
    fi

    echo -e "\n# --- OPTIONAL EXPORTS ---"
    AVAILABLE_EXPORTS=("bun" "docker" "go" "java-android-studio" "nvm" "pipx" "pnpm")

    for tool in "${AVAILABLE_EXPORTS[@]}"; do
        if [[ "$ALL_EXPORTS" == true ]] || [[ " ${SELECTED_EXPORTS[*]} " =~ " ${tool} " ]]; then
            echo "# Export: $tool"
            if [[ "$tool" == "pnpm" ]]; then
                # pnpm is OS-specific in your tree
                get_content ".zsh/$OS_TYPE/exports/pnpm.zsh"
            else
                # Others are in common
                get_content ".zsh/common/exports/$tool.zsh"
            fi
            echo ""
        fi
    done

} > "$ZSHRC_LOCAL"

echo "=== Setup Complete ==="