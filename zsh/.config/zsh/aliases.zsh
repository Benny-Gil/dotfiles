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
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
elif command -v batcat >/dev/null 2>&1; then  # Debian/Ubuntu package name
  alias bat='batcat'
  alias cat='batcat --paging=never'
fi
# Debian/Ubuntu ship fd as "fdfind"
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi
alias grep='grep --color=auto'  # rg stays rg — different flag semantics

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
alias myip='curl -s ifconfig.me; echo'  # NOT "ip" — that shadows the Linux ip(8) command

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
