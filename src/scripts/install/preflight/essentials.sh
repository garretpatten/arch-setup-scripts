#!/bin/bash

sudo pacman -S --needed --noconfirm git curl wget ca-certificates gnupg base-devel 2>/dev/null || true

if ! command -v yay >/dev/null 2>&1; then
    yay_build_dir="$TEMP_DIR/yay"
    rm -rf "$yay_build_dir" 2>/dev/null || true
    if git clone https://aur.archlinux.org/yay.git "$yay_build_dir" 2>/dev/null && [[ -d "$yay_build_dir" ]]; then
        (cd "$yay_build_dir" && makepkg -sri --noconfirm 2>/dev/null) || true
    fi
fi

if command -v yay >/dev/null 2>&1; then
    yay -Yc --noconfirm 2>/dev/null || true
fi
