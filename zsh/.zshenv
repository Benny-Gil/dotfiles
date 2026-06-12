# ~/.zshenv — runs for EVERY zsh invocation (including scripts).
# Keep this minimal: env only, no output, everything guarded.

# Rust toolchain env (sets PATH for cargo/rustup)
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
