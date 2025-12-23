#!/usr/bin/env bash
set -e

REPO_URL="https://raw.githubusercontent.com/huffmanks/config-stash/main/.dotfiles"
ZSHRC_LOCAL="$HOME/.zshrc"

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
        --exports)
            shift
            while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                if [[ "$1" == "all" ]]; then
                    ALL_EXPORTS=true
                else
                    SELECTED_EXPORTS+=("$1")
                fi
                shift
            done
            ;;
        *)
            shift
            ;;
    esac
done

# Helper: Print remote file content to stdout
get_content() {
    local title="$1"
    local path="$2"
    local url="$REPO_URL/$path"

    # Get HTTP status and content separately
    local response
    response=$(curl -sL -w "%{http_code}" "$url" -o /tmp/dotfile_part)

    if [[ "$response" == "200" ]]; then
        local content
        content=$(cat /tmp/dotfile_part)
        if [[ -n "$content" ]]; then
            printf "%s\n\n" "$content"
            echo "[MERGED] $title ==> .zshrc" >&2
        fi
    else
        echo "[SKIP] $title =X= (Not found in repo)" >&2
    fi
    rm -f /tmp/dotfile_part
}

# Helper: Copy standalone file only if it exists in repo
fetch_to_file() {
    local title="$1"
    local remote_path="$2"
    local local_path="$3"

    if curl -fsSL -I "$REPO_URL/$remote_path" >/dev/null 2>&1; then
        echo "[COPY] $title ==> $local_path"
        curl -fsSL "$REPO_URL/$remote_path" -o "$local_path"
    else
        echo "[SKIP] $remote_path =X= (Not found in repo)" >&2
    fi
}

# Copy standalone dotfiles
fetch_to_file ".gitconfig" ".gitconfig" "$HOME/.gitconfig"
fetch_to_file ".gitignore" ".gitignore" "$HOME/.gitignore"
fetch_to_file ".zprofile" ".zsh/$OS_TYPE/$ARCH_TYPE/.zprofile" "$HOME/.zprofile"

# Generate .zshrc
printf "\n [BUILD] Generating .zshrc \n\n"

{
    # 1. Config
    get_content "Config (common)" ".zsh/common/config.zsh"

    # 2. Exports
    AVAILABLE_EXPORTS=("bun" "docker" "go" "java-android-studio" "nvm" "pipx" "pnpm")
    # Add any additional exports here that are OS-specific
    OS_SPECIFIC_EXPORTS=("pnpm")

    SHOW_HEADER=false
    [[ "$ALL_EXPORTS" == true ]] && SHOW_HEADER=true
    for t in "${SELECTED_EXPORTS[@]}"; do SHOW_HEADER=true; done

    if [[ "$SHOW_HEADER" == true ]]; then
        echo "# ====================================="
        echo "# Exports"
        echo "# ====================================="
        echo ""
    fi

    for tool in "${AVAILABLE_EXPORTS[@]}"; do
        if [[ "$ALL_EXPORTS" == true ]] || [[ " ${SELECTED_EXPORTS[*]} " =~ " ${tool} " ]]; then

             # OS-specific exports
            if [[ " ${OS_SPECIFIC_EXPORTS[*]} " =~ " ${tool} " ]]; then
                get_content "Exports ==> ($OS_TYPE:$tool)" ".zsh/$OS_TYPE/exports/$tool.zsh"
            else
                # Others are common
                get_content "Exports ==> ($tool)" ".zsh/common/exports/$tool.zsh"
            fi
        fi
    done

    # 3. Prompt
    get_content "Prompt (common)" ".zsh/common/prompt.zsh"

    # 4. Aliases
    get_content "Aliases (common)" ".zsh/common/aliases.zsh"
    # --- OS-specific aliases
    get_content "Aliases ($OS_TYPE)" ".zsh/$OS_TYPE/aliases.zsh"

    # 5. Plugins
    # --- OS-specific plugins
    get_content "Plugins ($OS_TYPE)" ".zsh/$OS_TYPE/plugins.zsh"
    # --- Architecture-specific plugins
    get_content "Plugins ($OS_TYPE:$ARCH_TYPE)" ".zsh/$OS_TYPE/$ARCH_TYPE/plugins.zsh"

} > "$ZSHRC_LOCAL"

echo "===== Setup Complete ====="