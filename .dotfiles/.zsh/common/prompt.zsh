# =====================================
# Prompt (common)
# =====================================

# ----- Git info -----
get_git_info() {
  # Check if we are in a git repo once
  local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  [[ -z "$git_root" ]] && return

  local ref=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  # Output the formatted string: git:(branch)
  echo "%{%F{blue}%B%}git:(%{%b%F{red}%}${ref}%{%F{blue}%})%{%f%} "
}

# ----- Middle section (Host:Path OR GitRoot) -----
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

# ----- Left prompt -----
PROMPT='%(?.%F{green}%B>%b.%F{red}%B>%b) $(get_middle_section) $(get_git_info)%F{yellow}$%f '

# ----- Right prompt (time) -----
RPROMPT='%F{242}[%D{%H:%M:%S}]%f'

# ----- Ensure blinking cursor -----
echo -ne '\e[1 q'