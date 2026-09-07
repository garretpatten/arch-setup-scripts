#!/bin/bash

# Arch package maintenance helpers (pacman equivalents of apt update/cleanup).

package_maintain_update() {
    sudo pacman -Sy --noconfirm || true
}

package_maintain_full_upgrade() {
    sudo pacman -Syu --noconfirm || true
}

package_maintain_cleanup() {
    if command -v yay >/dev/null 2>&1; then
        yay -Yc --noconfirm 2>/dev/null || true
    fi
    sudo pacman -Sc --noconfirm 2>/dev/null || true
}
