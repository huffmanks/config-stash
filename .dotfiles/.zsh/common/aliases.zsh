# =====================================
# Aliases (common)
# =====================================

# ----- Opinionated defaults -----
alias grep='grep --color=auto'        # Shows matches in color
alias rm='rm -i'                      # Always prompt before removing files
alias mkdir='mkdir -p'                # Automatically create parent directories as needed

# ----- Traversing -----
alias ..='cd ..'                      # Go up one directory
alias ...='cd ../../../'              # Go up three directories
alias ....='cd ../../../../'          # Go up four directories
alias ~="cd ~"                        # Go to home directory

# ----- Git -----
alias gs='git status'                 # Quick git status
alias ga='git add'                    # Stage files for commit
alias gc='git commit'                 # Commit staged changes
alias gp='git push'                   # Push commits to a remote repository
alias gd='git diff'                   # Show unstaged differences since last commit
alias glog='git log --oneline --graph --decorate' # Pretty git log
alias gfu='git fetch origin && git reset --hard origin/main && git clean -fd'  # Force update: reset local branch and files to match remote
alias gsu='git submodule update --remote --merge'  # Update submodules to latest remote commit with merge

# ----- Shawtys -----
alias hg='history | grep'             # Search history
alias rg='grep -rHn'                  # Recursive, display filename and line number