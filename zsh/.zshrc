# ~/.zshrc — interactive shell config
# Managed by ~/dotfiles (stow). Cross-platform: macOS + Linux.
# Everything machine-specific or optional is guarded, so this file is safe
# to load on a box that has none of the optional tools installed.

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

# --- Powerlevel10k instant prompt (must run before anything that prints) --
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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

# --- Extra completion dirs (must precede compinit) -------------------------
[[ -d "$HOME/.oh-my-zsh/custom/completions" ]] && fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)

# --- oh-my-zsh if installed; otherwise plain compinit ----------------------
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME=""        # prompt handled below (p10k / starship)
  plugins=(git)
  source "$ZSH/oh-my-zsh.sh"   # runs compinit itself
else
  autoload -Uz compinit
  # Full (security-checked) compinit only if the dump is missing or >24h old.
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh-24) ]]; then
    compinit -C   # dump is fresh (<24h)
  else
    compinit      # missing or stale -> full init
  fi
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- Keybindings ------------------------------------------------------------
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# --- Source split config ----------------------------------------------------
# Order matters: exports defines path helpers used by devtools.
for f in "$HOME/.config/zsh/exports.zsh" \
         "$HOME/.config/zsh/devtools.zsh" \
         "$HOME/.config/zsh/aliases.zsh"; do
  [[ -r "$f" ]] && source "$f"
done

# --- Tool integrations (only if installed) ----------------------------------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"        # z / zi
command -v fzf    >/dev/null 2>&1 && eval "$(fzf --zsh 2>/dev/null)"  # Ctrl-R/T, needs fzf >= 0.48

# iTerm2 shell integration (macOS, harmless elsewhere)
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# --- Local, untracked overrides (machine-specific secrets) ------------------
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# --- Prompt: p10k > starship > built-in fallback -----------------------------
if [[ -r "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
  [[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
elif command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats ' (%b)'
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%~%f%F{yellow}${vcs_info_msg_0_}%f %# '
fi

# --- Autosuggestions + syntax highlighting (highlighting must load LAST) ----
for _zplug in \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"; do
  [[ -r "$_zplug" ]] && source "$_zplug" && break
done
for _zplug in \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
  [[ -r "$_zplug" ]] && source "$_zplug" && break
done
unset _zplug
