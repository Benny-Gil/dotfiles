# ~/.config/zsh/aliases.zsh — aliases & small functions

# --- ls: prefer eza, fall back to coreutils with the right color flag -----
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lh --git --group-directories-first'
  alias la='eza -lah --git --group-directories-first'
  alias tree='eza --tree'
else
  if [[ "$DOTFILES_OS" == "macos" ]]; then
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi
  alias ll='ls -lh'
  alias la='ls -lah'
fi

# --- Modern replacements (used only if installed) -------------------------
command -v bat  >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v fd   >/dev/null 2>&1 || alias fd='find'
command -v rg   >/dev/null 2>&1 && alias grep='rg' || alias grep='grep --color=auto'

# --- Navigation -----------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# --- Git ------------------------------------------------------------------
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpl='git pull'

# --- Misc -----------------------------------------------------------------
alias reload='exec zsh'
alias path='echo $PATH | tr ":" "\n"'
alias ip='curl -s ifconfig.me; echo'

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract most archive types
extract() {
  [[ -f "$1" ]] || { echo "extract: '$1' is not a file"; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf  "$1" ;;
    *.gz)             gunzip  "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.zip)            unzip   "$1" ;;
    *.7z)             7z x    "$1" ;;
    *)                echo "extract: don't know how to handle '$1'" ;;
  esac
}
