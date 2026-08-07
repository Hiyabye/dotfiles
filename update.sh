#!/bin/sh

set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Helper function to handle downloads across curl and wget
download_file() {
  url="$1"
  dest="$2"

  mkdir -p "$(dirname -- "$dest")"
  printf 'Downloading %s...\n' "$dest"

  if command -v curl >/dev/null 2>&1; then
    curl -sSL "$url" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url"
  else
    printf 'Error: Neither curl nor wget is available.\n' >&2
    return 1
  fi
}

# --- Module Updates ---

update_ghostty() {
  printf '\n--- Updating Ghostty dependencies ---\n'
  glsl_url="https://raw.githubusercontent.com/sahaj-b/ghostty-cursor-shaders/refs/heads/main/cursor_warp.glsl"
  download_file "$glsl_url" "$DOTFILES_DIR/ghostty/shaders/cursor_warp.glsl"
}

update_nvim() {
  printf '\n--- Updating Neovim dependencies ---\n'
  # Nothing to update for Neovim at the moment
}

# Main execution loop
main() {
  update_ghostty
  update_nvim
}

main "$@"
