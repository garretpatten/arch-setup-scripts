#!/bin/bash

sudo npm install -g bash-language-server pyright typescript-language-server yaml-language-server \
    --loglevel=error --no-update-notifier 2>/dev/null || true

# lua-language-server is available in the official Arch repositories.
if ! command -v lua-language-server >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm lua-language-server 2>/dev/null || true
fi
