#!/bin/sh

set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

# Safe symlink helper function
safe_link() {
  src_path="$1"
  target_path="$2"

  if [ ! -e "$src_path" ]; then
    printf 'Error: Source missing at %s\n' "$src_path" >&2
    return 1
  fi

  if [ -L "$target_path" ]; then
    curr_target=$(readlink "$target_path" 2>/dev/null || true)
    if [ "$curr_target" = "$src_path" ]; then
      printf 'Already linked: %s -> %s\n' "$target_path" "$src_path"
      return 0
    fi
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    printf 'Error: Target %s exists and is not linked to %s. Move/remove it first.\n' "$target_path" "$src_path" >&2
    return 1
  fi

  mkdir -p "$(dirname -- "$target_path")"
  ln -s "$src_path" "$target_path"
  printf 'Linked: %s -> %s\n' "$target_path" "$src_path"
}

# Run dependencies update first
if [ -f "$DOTFILES_DIR/update.sh" ]; then
  printf 'Running update script...\n'
  sh "$DOTFILES_DIR/update.sh"
else
  printf 'Warning: update.sh not found in %s\n' "$DOTFILES_DIR" >&2
fi

# Ensure base config directory exists
mkdir -p "$CONFIG_HOME"

# Ghostty setup
if command -v ghostty >/dev/null 2>&1; then
  safe_link "$DOTFILES_DIR/ghostty" "$CONFIG_HOME/ghostty"
else
  printf 'Warning: Ghostty is not installed. Skipping symlink.\n' >&2
fi

# Neovim setup
if command -v nvim >/dev/null 2>&1; then
  safe_link "$DOTFILES_DIR/nvim" "$CONFIG_HOME/nvim"
else
  printf 'Warning: Neovim is not installed. Skipping symlink.\n' >&2
fi
