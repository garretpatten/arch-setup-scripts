#!/bin/bash

# Spotify
if [[ -d "/usr/bin/spotify-launcher" ]]; then
    echo "Spotify is already installed."
else
    sudo pacman -S spotify-launcher --noconfirm
fi

# VLC
if [[ -f "/usr/bin/vlc" ]]; then
    echo "VLC Media Player is already installed."
else
    sudo pacman -S vlc --noconfirm
fi
