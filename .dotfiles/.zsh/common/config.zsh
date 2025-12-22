# =====================================
# Config (common)
# =====================================

export TZ="America/New_York"

if [ "$TERM" = "xterm" ]; then
  export TERM="xterm-256color"
fi

# ----- zsh config -----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt inc_append_history
setopt share_history
setopt PROMPT_SUBST