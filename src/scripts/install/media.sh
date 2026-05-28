#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

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
