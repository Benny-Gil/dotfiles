#!/usr/bin/env bash
# bootstrap.sh — set up dotfiles on a fresh macOS or Linux machine.
#
#   ./bootstrap.sh              # install packages + stow everything
#   ./bootstrap.sh --no-install # just stow (skip package installation)
#   ./bootstrap.sh --unstow     # remove all symlinks
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh git nvim tmux starship)

# --- pretty logging -------------------------------------------------------
info()  { printf '\033[0;34m::\033[0m %s\n' "$*"; }
ok()    { printf '\033[0;32mok\033[0m %s\n' "$*"; }
warn()  { printf '\033[0;33m!!\033[0m %s\n' "$*"; }
die()   { printf '\033[0;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

detect_os() {
  case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
    *)      die "Unsupported OS: $(uname -s)" ;;
  esac
}

# --- package installation -------------------------------------------------
install_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    info "Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$([ -x /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv)"
  fi
  info "Installing packages from Brewfile…"
  brew bundle --file="$DOTFILES_DIR/packages/Brewfile"
  ok "Homebrew packages installed"
}

install_linux() {
  command -v apt-get >/dev/null 2>&1 || { warn "Non-apt Linux: install packages manually (see packages/apt.txt)"; return; }
  info "Installing apt packages…"
  local pkgs
  pkgs=$(grep -vE '^\s*#|^\s*$' "$DOTFILES_DIR/packages/apt.txt" | tr '\n' ' ')
  sudo apt-get update
  # shellcheck disable=SC2086
  sudo apt-get install -y $pkgs
  command -v stow >/dev/null 2>&1 || sudo apt-get install -y stow
  ok "apt packages installed"
}

# --- stow -----------------------------------------------------------------
ensure_stow() {
  command -v stow >/dev/null 2>&1 && return
  warn "GNU Stow not found."
  [[ "$OS" == "macos" ]] && brew install stow || sudo apt-get install -y stow
}

# Back up any real (non-symlink) file that stow would clobber.
backup_conflicts() {
  local backup_dir="$HOME/.dotfiles-backup"
  local moved=0
  for pkg in "${PACKAGES[@]}"; do
    while IFS= read -r -d '' src; do
      local rel="${src#"$DOTFILES_DIR/$pkg/"}"
      local target="$HOME/$rel"
      if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$backup_dir/$(dirname "$rel")"
        mv "$target" "$backup_dir/$rel"
        warn "backed up $target -> $backup_dir/$rel"
        moved=1
      fi
    done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)
  done
  [[ $moved -eq 1 ]] && info "Conflicts saved under $backup_dir"
}

stow_all() {
  ensure_stow
  backup_conflicts
  for pkg in "${PACKAGES[@]}"; do
    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg"
    ok "stowed $pkg"
  done
}

unstow_all() {
  for pkg in "${PACKAGES[@]}"; do
    stow --dir="$DOTFILES_DIR" --target="$HOME" --delete "$pkg" && ok "unstowed $pkg"
  done
}

# --- main -----------------------------------------------------------------
main() {
  detect_os
  info "Detected OS: $OS"
  case "${1:-}" in
    --unstow)     unstow_all; exit 0 ;;
    --no-install) stow_all ;;
    "")           [[ "$OS" == "macos" ]] && install_macos || install_linux; stow_all ;;
    *)            die "Unknown option: $1" ;;
  esac
  ok "Done. Restart your shell:  exec zsh"
}

main "$@"
