#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

sudo pacman -Syu --noconfirm 2>>"$ERROR_LOG_FILE" || true

if command -v yay >/dev/null 2>&1; then
    yay -Yc --noconfirm 2>>"$ERROR_LOG_FILE" || true
fi

if command -v docker >/dev/null 2>&1; then
    sudo systemctl enable docker.service 2>>"$ERROR_LOG_FILE" || true
    sudo systemctl start docker.service 2>>"$ERROR_LOG_FILE" || true
    sudo usermod -aG docker "$USER" 2>>"$ERROR_LOG_FILE" || true
fi

if command -v ufw >/dev/null 2>&1; then
    sudo ufw --force enable 2>>"$ERROR_LOG_FILE" || true
fi

wolf_art_file="$PROJECT_ROOT/src/assets/wolf.txt"
if [[ -f "$wolf_art_file" ]]; then
    echo
    echo "============================================================================"
    cat "$wolf_art_file" 2>/dev/null || true
    echo "============================================================================"
    echo
fi

echo "Setup completed. Check $ERROR_LOG_FILE for any errors."
