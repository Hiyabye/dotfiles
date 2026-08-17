#!/usr/bin/env bash

set -uo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly root_dir
portable_only=false
failures=0
skipped=0

if [[ "${1:-}" == "--portable" ]]; then
  portable_only=true
elif (($# > 0)); then
  printf 'Usage: %s [--portable]\n' "${0##*/}" >&2
  exit 2
fi

run_check() {
  local name="$1"
  shift

  printf '%-30s' "$name"
  if "$@"; then
    printf 'ok\n'
  else
    printf 'failed\n' >&2
    ((failures += 1))
  fi
}

skip_check() {
  printf '%-30sskipped (%s not installed)\n' "$1" "$2"
  ((skipped += 1))
}

check_lua_syntax() {
  find "$root_dir/hypr" "$root_dir/nvim" -type f \( -name '*.lua' -o -name '*.lua.example' \) \
    ! -name 'local.lua' -exec luac -p {} +
}

check_lua_format() {
  mapfile -d '' files < <(
    find "$root_dir/hypr" "$root_dir/nvim" -type f \( -name '*.lua' -o -name '*.lua.example' \) \
      ! -name 'local.lua' -print0
  )
  stylua --check --config-path "$root_dir/stylua.toml" -- "${files[@]}"
}

check_shell_format() {
  mapfile -d '' files < <(find "$root_dir" -type f -name '*.sh' -print0)
  shfmt -d -i 2 -ci -bn -- "${files[@]}"
}

check_shell_scripts() {
  mapfile -d '' files < <(find "$root_dir" -type f -name '*.sh' -print0)
  shellcheck --external-sources -- "${files[@]}"
}

check_json() {
  jq empty "$root_dir/fastfetch/config.jsonc" "$root_dir/nvim/lazy-lock.json" >/dev/null
}

check_whitespace() {
  ! git -C "$root_dir" grep -nI -E '[[:blank:]]+$' -- . ':!ghostty/shaders/cursor_warp.glsl'
}

check_ghostty() {
  ghostty +validate-config --config-file="$root_dir/ghostty/config.ghostty"
}

check_hyprland() {
  hyprland --verify-config --config "$root_dir/hypr/hyprland.lua" >/dev/null
}

check_fastfetch() {
  fastfetch --config "$root_dir/fastfetch/config.jsonc" --pipe false >/dev/null
}

check_neovim() {
  local temporary_dir
  temporary_dir="$(mktemp -d)"
  mkdir -p "$temporary_dir/config"
  ln -s "$root_dir/nvim" "$temporary_dir/config/nvim"
  XDG_CONFIG_HOME="$temporary_dir/config" nvim --headless '+quitall'
  local status=$?
  rm -rf -- "$temporary_dir"
  return "$status"
}

cd -- "$root_dir" || exit

if command -v luac >/dev/null 2>&1; then
  run_check "Lua syntax" check_lua_syntax
else
  skip_check "Lua syntax" "luac"
fi

if command -v stylua >/dev/null 2>&1; then
  run_check "Lua formatting" check_lua_format
else
  skip_check "Lua formatting" "stylua"
fi

if command -v shfmt >/dev/null 2>&1; then
  run_check "Shell formatting" check_shell_format
else
  skip_check "Shell formatting" "shfmt"
fi

if command -v shellcheck >/dev/null 2>&1; then
  run_check "Shell lint" check_shell_scripts
else
  skip_check "Shell lint" "shellcheck"
fi

if command -v jq >/dev/null 2>&1; then
  run_check "JSON syntax" check_json
else
  skip_check "JSON syntax" "jq"
fi

if command -v git >/dev/null 2>&1; then
  run_check "Trailing whitespace" check_whitespace
else
  skip_check "Trailing whitespace" "git"
fi

if [[ "$portable_only" != true ]]; then
  if command -v ghostty >/dev/null 2>&1; then
    run_check "Ghostty configuration" check_ghostty
  else
    skip_check "Ghostty configuration" "ghostty"
  fi

  if command -v hyprland >/dev/null 2>&1; then
    run_check "Hyprland configuration" check_hyprland
  else
    skip_check "Hyprland configuration" "hyprland"
  fi

  if command -v fastfetch >/dev/null 2>&1; then
    run_check "Fastfetch configuration" check_fastfetch
  else
    skip_check "Fastfetch configuration" "fastfetch"
  fi

  if command -v nvim >/dev/null 2>&1; then
    run_check "Neovim startup" check_neovim
  else
    skip_check "Neovim startup" "nvim"
  fi
fi

printf '\nChecks: %d failed, %d skipped.\n' "$failures" "$skipped"
((failures == 0))
