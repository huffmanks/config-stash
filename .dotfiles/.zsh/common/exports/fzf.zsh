# ----- fzf -----
source <(fzf --zsh)

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS="
  --layout=reverse
  --height=80%
  --border
  --preview 'cat {}'
"

export FZF_COMPLETION_TRIGGER='**'