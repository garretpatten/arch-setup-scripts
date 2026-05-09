#!/usr/bin/env bash
# Expect cwd = repo root. Only fails on explicit log_error() lines, not raw stderr
# (pacman/curl/go/docker/sysctl/ufw/etc.) copied into setup_errors.log.
set -euo pipefail

ERROR_LOG="setup_errors.log"
[[ -f "$ERROR_LOG" && -s "$ERROR_LOG" ]] || exit 0

# Matches: echo "[$(date ...)] ERROR: ..." >> ERROR_LOG_FILE (utils.sh log_error)
logged_errors=$(mktemp)
grep -E '^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}\] ERROR:' \
  "$ERROR_LOG" >"$logged_errors" || true

if [[ -s "$logged_errors" ]]; then
  echo '❌ Errors found:'
  cat "$logged_errors"
  rm -f "$logged_errors"
  exit 1
fi
rm -f "$logged_errors"
