#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

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

arch_art_file="$PROJECT_ROOT/src/assets/arch.txt"
if [[ -f "$arch_art_file" ]]; then
    echo
    echo "============================================================================"
    cat "$arch_art_file" 2>/dev/null || true
    echo "============================================================================"
    echo
fi

echo "Setup completed. Check $ERROR_LOG_FILE for any errors."
