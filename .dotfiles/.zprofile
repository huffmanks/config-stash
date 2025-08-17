# Homebrew setup (macOS only)
if [[ "$(uname)" = "Darwin" ]]; then
  # macOS Apple silicon arm64
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    arch=$(file -b /opt/homebrew/bin/brew)
    [[ "$arch" = *arm64* ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # macOS Intel x86_64
  if [[ -x "/usr/local/bin/brew" ]]; then
    arch=$(file -b /usr/local/bin/brew)
    [[ "$arch" = *x86_64* ]] && eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
