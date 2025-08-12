# ==============================
# Linux .zshrc
# ==============================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt inc_append_history
setopt share_history

# ----- NVM Setup -----
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# ----- PNPM Setup -----
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ----- Aliases -----
# Opinionated defaults
alias ls='ls -A'                      # List all entries except . and ..
alias grep='grep --color=auto'        # Shows matches in color
alias rm='rm -i'                      # Always prompt before removing files
alias mkdir='mkdir -p'                # Automatically create parent directories as needed
alias cat='batcat'                    # Use bat for syntax highlighting if installed

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

# ----- zsh-autosuggestions -----
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ----- zsh-syntax-highlighting -----
# Must be last
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi