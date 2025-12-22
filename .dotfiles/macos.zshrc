# ==============================
# macOS .zshrc
# ==============================

export TZ="America/New_York"

# ----- NVM -----
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf "%s" "${HOME}/.nvm" || printf "%s" "${XDG_CONFIG_HOME}/nvm")"
# Remove --no-use to disable lazy load
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# ----- PNPM -----
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ----- Bun -----
[ -s "/Users/huffmanks/.bun/_bun" ] && source "/Users/huffmanks/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ----- Docker -----
fpath=($HOME/.docker/completions $fpath)

# ----- PIPX -----
export PATH="$HOME/.local/bin:$PATH"

# ----- Java & Android Studio -----
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# ----- Aliases -----
# Opinionated defaults
alias ls='ls -A'                      # List all entries except . and ..
alias grep='grep --color=auto'        # Shows matches in color
alias rm='rm -i'                      # Always prompt before removing files
alias mkdir='mkdir -p'                # Automatically create parent directories as needed
alias cat='bat'                       # Use bat for syntax highlighting if installed

# Traversing
alias ..='cd ..'                      # Go up one directory
alias ...='cd ../../../'              # Go up three directories
alias ....='cd ../../../../'          # Go up four directories
alias ~="cd ~"                        # Go to home directory

# Git
alias gs='git status'                 # Quick git status
alias ga='git add'                    # Stage files for commit
alias gc='git commit'                 # Commit staged changes
alias gp='git push'                   # Push commits to a remote repository
alias gd='git diff'                   # Show unstaged differences since last commit
alias glog='git log --oneline --graph --decorate' # Pretty git log
alias gfu='git fetch origin && git reset --hard origin/main && git clean -fd'  # Force update: reset local branch and files to match remote
alias gsu='git submodule update --remote --merge'  # Update submodules to latest remote commit with merge

# Shawtys
alias hg='history | grep'             # Search history
alias rg='grep -rHn'                  # Recursive, display filename and line number

# ----- Prompt styles -----
setopt PROMPT_SUBST

# Helper to get Git info in one go to prevent cursor lag
get_git_info() {
  # Check if we are in a git repo once
  local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  [[ -z "$git_root" ]] && return

  local ref=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  # Output the formatted string: git:(branch)
  # Wrapped in %{ %} to tell Zsh these are non-printing characters
  echo "%{%F{blue}%B%}git:(%{%b%F{red}%}${ref}%{%F{blue}%})%{%f%} "
}

# Logic for the middle section (Host:Path OR GitRoot)
get_middle_section() {
  local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -n "$git_root" ]]; then
    # In Git: Magenta Git Root Name (basename of the root path)
    echo "%F{magenta}${git_root:t}%f"
  else
    # Not in Git: Magenta Hostname + Cyan Path
    local path_out="%~"
    echo "%F{magenta}%m%f %F{cyan}${path_out}%f"
  fi
}

# Left Prompt Construction
# Using %{ %} around the dynamic functions ensures the cursor doesn't drift
PROMPT='%(?.%F{green}%B>%b.%F{red}%B>%b) $(get_middle_section) $(get_git_info)%F{yellow}$%f '

# Right Prompt (Gray time)
RPROMPT='%F{242}[%D{%H:%M:%S}]%f'

# Ensure the cursor remains a blinking block (common fix for Ubuntu/GNOME terminal)
echo -ne '\e[1 q'

# ----- Plugins -----
# --- macOS Apple silicon arm64 ---
# --- zsh-autosuggestions ---
if [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# --- zsh-syntax-highlighting ---
# Must be last
if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- macOS Intel x86_64 ---
# --- zsh-autosuggestions ---
if [ -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# --- zsh-syntax-highlighting ---
# Must be last
if [ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
