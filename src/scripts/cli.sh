#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

update_pacman_cache

install_pacman_packages "flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

cli_tools=(
    "bat"
    "curl"
    "eza"
    "fastfetch"
    "fd"
    "git"
    "htop"
    "jq"
    "ripgrep"
    "vim"
    "wget"
)
install_pacman_packages "${cli_tools[@]}"
