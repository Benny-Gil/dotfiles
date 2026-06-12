# ~/.config/zsh/devtools.zsh — language version managers.
# Every block is guarded: machines without the tool skip it silently.
# Requires path_prepend from exports.zsh (sourced first by .zshrc).

# --- pyenv ------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT" ]]; then
  path_prepend "$PYENV_ROOT/bin"
  # Remove stale rehash lock file if it exists (prevents 60s hang on startup)
  [[ -f "$PYENV_ROOT/shims/.pyenv-shim" ]] && rm -f "$PYENV_ROOT/shims/.pyenv-shim"
  if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
  fi
fi

# --- nvm (lazy-loaded: saves ~500ms on startup) ------------------------------
export NVM_DIR="$HOME/.nvm"
_nvm_script=""
for _c in "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/nvm/nvm.sh" "$NVM_DIR/nvm.sh"; do
  if [[ -s "$_c" ]]; then _nvm_script="$_c"; break; fi
done
if [[ -n "$_nvm_script" ]]; then
  _load_nvm() {
    unset -f nvm node npm npx yarn 2>/dev/null
    source "$_nvm_script"
    local _compl="${_nvm_script%/nvm.sh}/etc/bash_completion.d/nvm"
    [[ -s "$_compl" ]] && source "$_compl"
  }
  nvm()  { _load_nvm; nvm  "$@"; }
  node() { _load_nvm; node "$@"; }
  npm()  { _load_nvm; npm  "$@"; }
  npx()  { _load_nvm; npx  "$@"; }
  yarn() { _load_nvm; yarn "$@"; }
fi
unset _c

# --- SDKMAN ------------------------------------------------------------------
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
