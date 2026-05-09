#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

update_pacman_cache

libreoffice_packages=(
    "libreoffice-fresh"
    "breeze-icons"
)
install_pacman_packages "${libreoffice_packages[@]}"

install_aur_packages "zoom"

if command -v flatpak >/dev/null 2>&1 && flatpak remote-info flathub >/dev/null 2>&1; then
    flatpak install -y flathub org.standardnotes.standardnotes 2>>"$ERROR_LOG_FILE" || true
fi

productivity_packages=(
    "keepassxc"
    "redshift"
    "flameshot"
)
install_pacman_packages "${productivity_packages[@]}"

# AUR conflicts / flaky deps; skip in Docker CI (ARCH_SETUP_CI=1).
if [[ "${ARCH_SETUP_CI:-}" != "1" ]]; then
    install_aur_packages "balena-etcher"
fi
