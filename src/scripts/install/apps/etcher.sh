#!/bin/bash

if command -v balena-etcher >/dev/null 2>&1; then
    exit 0
fi
if pacman -Q balena-etcher >/dev/null 2>&1; then
    exit 0
fi

# AUR conflicts / flaky deps; skip in Docker CI (ARCH_SETUP_CI=1).
if [[ "${ARCH_SETUP_CI:-}" == "1" ]]; then
    exit 0
fi

if ! command -v yay >/dev/null 2>&1; then
    exit 0
fi

yay -S --needed --noconfirm balena-etcher 2>/dev/null || true
