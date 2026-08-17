#!/usr/bin/env bash

set -u

readonly interval="${MAIL_SYNC_INTERVAL:-60}"
readonly hook="${MAIL_SYNC_HOOK:-}"
readonly lock_dir="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
readonly lock_file="$lock_dir/mail-sync-${UID}.lock"
mode="loop"

usage() {
  printf 'Usage: %s [--once]\n' "${0##*/}"
}

sync_mail() {
  local status=0

  if ! mbsync --all --quiet; then
    printf 'mail-sync: mbsync failed\n' >&2
    status=1
  fi

  if [[ -n "$hook" ]]; then
    if [[ ! -x "$hook" ]]; then
      printf 'mail-sync: hook is not executable: %s\n' "$hook" >&2
      status=1
    elif ! "$hook"; then
      printf 'mail-sync: hook failed: %s\n' "$hook" >&2
      status=1
    fi
  fi

  return "$status"
}

if (($# > 1)); then
  usage >&2
  exit 2
fi

case "${1:-}" in
  "") ;;
  --once)
    mode="once"
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if ! [[ "$interval" =~ ^[1-9][0-9]*$ ]]; then
  printf 'mail-sync: MAIL_SYNC_INTERVAL must be a positive integer\n' >&2
  exit 2
fi

if ! command -v mbsync >/dev/null 2>&1; then
  printf 'mail-sync: mbsync is not installed\n' >&2
  exit 127
fi

mkdir -p "$lock_dir"
exec 9>"$lock_file"
if command -v flock >/dev/null 2>&1 && ! flock --nonblock 9; then
  printf 'mail-sync: another instance is already running\n' >&2
  exit 0
fi

if [[ "$mode" == "once" ]]; then
  sync_mail
  exit
fi

while true; do
  sync_mail || true
  sleep "$interval"
done
