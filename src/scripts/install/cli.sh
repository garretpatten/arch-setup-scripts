#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_pacman_cache

install_pacman_packages "flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

cli_tools=(
    "bat"
    "btop"
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
