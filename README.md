# dotfiles

Cross-platform (macOS + Linux) dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's inside

| Package    | Symlinks                                              |
| ---------- | ----------------------------------------------------- |
| `zsh`      | `.zshrc`, `.config/zsh/{exports,aliases}.zsh`         |
| `git`      | `.gitconfig`, `.gitignore_global`                     |
| `nvim`     | `.config/nvim/init.lua`                               |
| `tmux`     | `.tmux.conf`                                          |
| `starship` | `.config/starship.toml`                               |

Each top-level folder is a **stow package**: its contents mirror your home
directory, so `zsh/.zshrc` → `~/.zshrc`.

## Quick start

```sh
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
exec zsh
```

`bootstrap.sh` will:

1. Detect macOS or Linux.
2. Install packages (Homebrew `Brewfile` on macOS, `apt.txt` on Debian/Ubuntu).
3. Back up any existing real files to `~/.dotfiles-backup/`.
4. Symlink everything with `stow`.

### Options

```sh
./bootstrap.sh --no-install   # skip package install, just symlink
./bootstrap.sh --unstow       # remove all symlinks
```

## Managing packages manually

```sh
stow zsh git nvim          # link specific packages
stow -D tmux               # unlink one package
stow -R zsh                # re-link after adding files
```

Run stow from the repo root (`~/dotfiles`).

## Adding a new config

1. Create a package dir mirroring `$HOME`, e.g. ` alacritty/.config/alacritty/alacritty.toml`.
2. Add the package name to the `PACKAGES` array in `bootstrap.sh`.
3. `stow alacritty`.

## Machine-specific overrides

These files are sourced if present but **not** tracked — put secrets / per-machine
tweaks here:

- `~/.zshrc.local` — extra shell config
- `~/.gitconfig.local` — e.g. work email, credential helper

## Cross-platform notes

- The zsh config detects the OS and loads the right Homebrew prefix
  (`/opt/homebrew`, `/usr/local`, or Linuxbrew).
- Aliases degrade gracefully: `eza`/`bat`/`rg`/`fd` are used only if installed,
  otherwise plain coreutils with the correct color flags per OS.
- Some apt tools use different binary names (`fdfind`, `batcat`) — see
  `packages/apt.txt`.
