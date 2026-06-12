#!/bin/sh

set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
APPS="ghostty nvim"

# Check every destination before creating any link.
for app in $APPS; do
  source_path=$DOTFILES_DIR/$app
  target_path=$CONFIG_HOME/$app

  if [ -L "$target_path" ]; then
    if [ "$(readlink "$target_path")" = "$source_path" ]; then
      continue
    fi

    printf 'Error: %s points somewhere else.\n' "$target_path" >&2
    exit 1
  fi

  if [ -e "$target_path" ]; then
    printf 'Error: %s already exists.\n' "$target_path" >&2
    exit 1
  fi
done

mkdir -p "$CONFIG_HOME"

for app in $APPS; do
  source_path=$DOTFILES_DIR/$app
  target_path=$CONFIG_HOME/$app

  if [ -L "$target_path" ]; then
    printf 'Already linked: %s\n' "$target_path"
  else
    ln -s "$source_path" "$target_path"
    printf 'Linked: %s -> %s\n' "$target_path" "$source_path"
  fi
done
