# ~/.zprofile — login shells only. Sets up PATH-level environment that
# GUI-launched terminals expect. Everything is guarded for cross-platform use.

# Homebrew (macOS arm64/x86 + Linuxbrew)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# OrbStack command-line tools (macOS; self-guarded)
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
