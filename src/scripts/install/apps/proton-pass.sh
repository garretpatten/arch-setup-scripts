#!/bin/bash
# Proton Pass desktop AUR package.

if command -v proton-pass >/dev/null 2>&1; then
    exit 0
fi
if pacman -Q proton-pass-bin >/dev/null 2>&1; then
    exit 0
fi

# AUR package is frequently flagged out-of-date; skip in Docker CI (ARCH_SETUP_CI=1).
if [[ "${ARCH_SETUP_CI:-}" == "1" ]]; then
    exit 0
fi

if ! command -v yay >/dev/null 2>&1; then
    exit 0
fi

yay -S --needed --noconfirm proton-pass-bin || true
