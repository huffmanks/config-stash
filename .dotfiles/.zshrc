# Plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf "%s" "${HOME}/.nvm" || printf "%s" "${XDG_CONFIG_HOME}/nvm")"
# Lazy load
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# Docker completions
fpath=($HOME/.docker/completions $fpath)

# pipx
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Java & Android Studio environment variables
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

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

# Shawtys
alias hg='history | grep'             # Search history
alias rg='grep -rHn'                  # Recursive, display filename and line number
