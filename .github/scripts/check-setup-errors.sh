#!/usr/bin/env bash
# Expect cwd = repo root (e.g. GitHub Actions working-directory).
set -euo pipefail

ERROR_LOG="setup_errors.log"
[[ -f "$ERROR_LOG" && -s "$ERROR_LOG" ]] || exit 0

noise=(
  'warning: .* is up to date'
  'skipping'
  'Synchronizing package databases'
  'there is nothing to do'
  '::'
  'chsh: PAM: Authentication failure'
  'Password:'
  'systemctl restart'
  '^Cloning into'
  '^Updating files:'
  '^Resolving '
  '^Connecting to '
  '^HTTP request sent'
  '^Length:'
  '^Saving to:'
  '^--[0-9]{4}-[0-9]{2}-[0-9]{2}'
  '^[0-9]{4}-[0-9]{2}-[0-9]{2}.*saved'
  '^[[:space:]]*[0-9]+K'
  'done\.$'
  '^[[:space:]]*100%'
  '^npm notice'
  '% Total'
  '% Received'
  '% Xferd'
  'Average Speed'
  'Dload  Upload'
  'Time    Time     Time  Current'
  '--:--:--'
)
IFS='|'
noise_regex="(${noise[*]})"
unset IFS

filtered=$(mktemp)
grep -v -E "$noise_regex" "$ERROR_LOG" | grep -v '^[[:space:]]*$' >"$filtered" || true

if [[ -s "$filtered" ]]; then
  echo '❌ Errors found:'
  cat "$filtered"
  rm -f "$filtered"
  exit 1
fi
rm -f "$filtered"
