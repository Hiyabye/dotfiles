#!/usr/bin/env bash

set -euo pipefail

dotfiles_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly dotfiles_dir
readonly config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_stamp="$(date +%Y%m%d-%H%M%S)"
readonly backup_stamp

force=false
conflicts=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--force]

Create symlinks from this repository into the current user's configuration
folders. Existing files are skipped by default. With --force, conflicts are
moved to timestamped backup paths before links are created.
EOF
}

safe_link() {
  local source_path="$1"
  local target_path="$2"
  local backup_path

  if [[ ! -e "$source_path" ]]; then
    printf 'error: source does not exist: %s\n' "$source_path" >&2
    exit 1
  fi

  if [[ -L "$target_path" ]] \
    && [[ "$(readlink -f -- "$target_path" 2>/dev/null || true)" == "$(readlink -f -- "$source_path")" ]]; then
    printf 'already linked  %s\n' "$target_path"
    return
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    if [[ "$force" != true ]]; then
      printf 'skipped         %s (already exists; use --force to back it up)\n' "$target_path" >&2
      ((conflicts += 1))
      return
    fi

    backup_path="${target_path}.bak.${backup_stamp}"
    if [[ -e "$backup_path" || -L "$backup_path" ]]; then
      backup_path="${backup_path}.$$"
    fi

    mv -- "$target_path" "$backup_path"
    printf 'backed up       %s -> %s\n' "$target_path" "$backup_path"
  fi

  mkdir -p -- "$(dirname -- "$target_path")"
  ln -s -- "$source_path" "$target_path"
  printf 'linked          %s -> %s\n' "$target_path" "$source_path"
}

while (($# > 0)); do
  case "$1" in
    --force)
      force=true
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'error: unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

safe_link "$dotfiles_dir/fastfetch" "$config_home/fastfetch"
safe_link "$dotfiles_dir/ghostty" "$config_home/ghostty"
safe_link "$dotfiles_dir/hypr" "$config_home/hypr"
safe_link "$dotfiles_dir/nvim" "$config_home/nvim"
safe_link "$dotfiles_dir/mbsync/mail-sync.sh" "$HOME/.local/bin/mail-sync"

if [[ -f "$dotfiles_dir/mbsync/mbsyncrc" ]]; then
  chmod 600 "$dotfiles_dir/mbsync/mbsyncrc"
  safe_link "$dotfiles_dir/mbsync/mbsyncrc" "$HOME/.mbsyncrc"
else
  printf 'mail config     skipped (copy mbsync/mbsyncrc.example to mbsync/mbsyncrc first)\n'
fi

if ((conflicts > 0)); then
  printf '\n%d target(s) were skipped; no existing files were changed.\n' "$conflicts" >&2
  exit 1
fi

printf '\nDotfiles installed successfully.\n'
