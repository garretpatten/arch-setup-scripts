#!/bin/bash

if command -v google-chrome >/dev/null 2>&1; then
    exit 0
fi
if pacman -Q google-chrome >/dev/null 2>&1; then
    exit 0
fi

if ! command -v yay >/dev/null 2>&1; then
    exit 0
fi

yay -S --needed --noconfirm google-chrome 2>/dev/null || true
