#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_pacman_cache

libreoffice_packages=(
    "libreoffice-fresh"
    "breeze-icons"
)
install_pacman_packages "${libreoffice_packages[@]}"

install_aur_packages "zoom"

productivity_packages=(
    "keepassxc"
    "redshift"
    "flameshot"
    "gnome-shell-extensions"
    "gnome-tweaks"
)
install_pacman_packages "${productivity_packages[@]}"

# AUR conflicts / flaky deps; skip in Docker CI (ARCH_SETUP_CI=1).
if [[ "${ARCH_SETUP_CI:-}" != "1" ]]; then
    install_aur_packages "balena-etcher"
fi

install_aur_packages "bruno"
