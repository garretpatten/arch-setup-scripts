#!/bin/bash

if pacman -Q proton-vpn-gtk-app >/dev/null 2>&1; then
    exit 0
fi

if ! command -v yay >/dev/null 2>&1; then
    exit 0
fi

protonvpn_packages=(
    proton-vpn-gtk-app
    libappindicator-gtk3
)

# shellcheck source=../../lib/gnome-session.sh
source "$(dirname "$0")/../../lib/gnome-session.sh"
if gnome_session_active; then
    protonvpn_packages+=(gnome-shell-extension-appindicator)
fi

yay -S --needed --noconfirm "${protonvpn_packages[@]}" 2>/dev/null || true
