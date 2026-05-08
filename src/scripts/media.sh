#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

update_pacman_cache

install_aur_packages "brave-bin"

install_pacman_packages "vlc"

install_pacman_packages "spotify-launcher"

multimedia_packages=(
    "ffmpeg"
    "gst-plugins-bad"
    "gst-plugins-ugly"
    "gst-libav"
)
install_pacman_packages "${multimedia_packages[@]}"

install_aur_packages "ttf-ms-fonts"
