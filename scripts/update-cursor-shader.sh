#!/usr/bin/env bash

set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly root_dir
readonly upstream="https://raw.githubusercontent.com/sahaj-b/ghostty-cursor-shaders/main"
temporary_dir="$(mktemp -d)"
readonly temporary_dir

trap 'rm -rf -- "$temporary_dir"' EXIT

download() {
  local url="$1"
  local destination="$2"

  if command -v curl >/dev/null 2>&1; then
    curl --fail --location --silent --show-error "$url" --output "$destination"
  elif command -v wget >/dev/null 2>&1; then
    wget --quiet --output-document="$destination" "$url"
  else
    printf 'error: curl or wget is required\n' >&2
    exit 127
  fi
}

update_file() {
  local source_name="$1"
  local destination="$2"
  local downloaded_file="$temporary_dir/$source_name"

  download "$upstream/$source_name" "$downloaded_file"
  if [[ -f "$destination" ]] && cmp --silent "$downloaded_file" "$destination"; then
    printf 'unchanged  %s\n' "$destination"
    return
  fi

  install -m 0644 "$downloaded_file" "$destination"
  printf 'updated    %s\n' "$destination"
}

update_file "cursor_warp.glsl" "$root_dir/ghostty/shaders/cursor_warp.glsl"
update_file "LICENSE" "$root_dir/ghostty/shaders/LICENSE"
