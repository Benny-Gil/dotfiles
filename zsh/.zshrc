# ~/.zshrc — interactive shell config
# Managed by ~/dotfiles (stow). Cross-platform: macOS + Linux.

# --- OS detection ---------------------------------------------------------
case "$OSTYPE" in
  darwin*) export DOTFILES_OS="macos" ;;
  linux*)  export DOTFILES_OS="linux" ;;
  *)       export DOTFILES_OS="unknown" ;;
esac

# --- Homebrew (macOS arm64/x86 + Linuxbrew) -------------------------------
if [[ "$DOTFILES_OS" == "macos" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- History --------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY EXTENDED_HISTORY

# --- Shell behaviour ------------------------------------------------------
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS NO_BEEP
setopt GLOB_DOTS NUMERIC_GLOB_SORT

# --- Completion -----------------------------------------------------------
autoload -Uz compinit
# Full (security-checked) compinit only if the dump is missing or >24h old;
# otherwise skip the check for faster startup.
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh-24) ]]; then
  compinit -C   # dump is fresh (<24h)
else
  compinit      # missing or stale -> full init
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ''

# --- Keybindings ----------------------------------------------------------
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# --- Tool integrations (only if installed) --------------------------------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"   # z / zi
command -v fzf    >/dev/null 2>&1 && eval "$(fzf --zsh 2>/dev/null)"  # Ctrl-R/T, needs fzf >= 0.48

# --- Source split config --------------------------------------------------
for f in "$HOME/.config/zsh/exports.zsh" "$HOME/.config/zsh/aliases.zsh"; do
  [[ -r "$f" ]] && source "$f"
done

# --- Local, untracked overrides (machine-specific secrets) ----------------
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# --- Prompt: starship if available, else a small fallback -----------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats ' (%b)'
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%~%f%F{yellow}${vcs_info_msg_0_}%f %# '
fi
