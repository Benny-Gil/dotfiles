# ~/.config/zsh/exports.zsh — environment variables & PATH

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R"
export LANG="en_US.UTF-8"

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# --- PATH helper: prepend if dir exists and not already present -----------
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) [[ -d "$1" ]] && PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# Language toolchains (only added if present)
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/go/bin"
[[ -d "$HOME/.local/share/mise" ]] && command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

export PATH
