# ==============================
# macOS .zshrc
# ==============================

export TZ="America/New_York"

# ----- NVM -----
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf "%s" "${HOME}/.nvm" || printf "%s" "${XDG_CONFIG_HOME}/nvm")"
# Remove --no-use to disable lazy load
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# ----- Docker -----
fpath=($HOME/.docker/completions $fpath)

# ----- PIPX -----
export PATH="$HOME/.local/bin:$PATH"

# ----- PNPM -----
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

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

get_git_root_name() {
  local root=$(git rev-parse --show-toplevel 2> /dev/null)
  echo "${root:t}"
}

# Logic for the middle section (Host:Path OR GitRoot)
get_middle_section() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # In Git: Magenta Git Root Name
    echo "%F{magenta}$(get_git_root_name)%f"
  else
    # Not in Git: Magenta Hostname + Cyan Path
    local path_out="%/"
    [[ "$PWD" == "$HOME" ]] || [[ "$PWD" == "$HOME"/* ]] && path_out="%~"
    echo "%F{magenta}%m%f %F{cyan}${path_out}%f"
  fi
}

# Git Info (Branch name)
git_branch_info() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return
  fi
  local ref=$(git branch --show-current 2> /dev/null)
  [[ -z $ref ]] && ref=$(git rev-parse --short HEAD 2> /dev/null)

  # Purple 'git:(' then Red 'branch' then Purple ')'
  echo "%F{blue}%Bgit:(%b%F{red}${ref}%F{blue})%f "
}

# Left Prompt Construction
PROMPT='%(?.%F{green}%B>%b.%F{red}%B>%b) $(get_middle_section) $(git_branch_info)%F{yellow}$%f '

# Right Prompt (Gray time)
RPROMPT='%F{242}[%D{%H:%M:%S}]%f'

# ----- Plugins -----
# --- zsh-autosuggestions ---
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- zsh-syntax-highlighting ---
# Must be last
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
