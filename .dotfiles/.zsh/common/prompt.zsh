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
  echo "%{%F{blue}%}git:(%{%F{green}%}${ref}%{%F{blue}%})%{%f%} "
}

# ----- Middle section (host, path, git) -----
get_middle_section() {
  local git_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -n "$git_root" ]]; then
    # Git path
    echo "%F{magenta}%m%f %F{cyan}${git_root:t}%f"
  else
    # Not Git path
    local path_out="%~"
    echo "%F{magenta}%m%f %F{cyan}${path_out}%f"
  fi
}

# ----- Prompt -----
# Line 1: ╭ host (magenta), path (cyan), git info (blue, visually purple), time (gray)
# Line 2: ╰ username:# (red) or username:$ (yellow)
PROMPT='%(!.%F{red}.%F{yellow})╭%f $(get_middle_section) $(get_git_info)%F{242}[%D{%H:%M:%S}]%f
%(!.%F{red}.%F{yellow})╰%f %(!.%F{red}root:#.%F{yellow}%n:$)%f '

# ----- Ensure blinking cursor -----
echo -ne '\e[1 q'