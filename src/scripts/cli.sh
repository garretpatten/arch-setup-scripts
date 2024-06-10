#!/bin/bash

cliTools=("alacritty" "bat" "curl" "exa" "fastfetch" "git" "htop" "neovim" "openvpn" "terminator" "tmux" "vim" "wget" "zsh")
for cliTool in "${cliTools[@]}"; do
    if [[ -d "/usr/bin/$cliTool" ]]; then
        echo "$cliTool is already installed."
    elif [[ -f "/usr/sbin/$cliTool" ]]; then
        echo "$cliTool is already installed."
    else
        sudo pacman -S "$cliTool" --noconfirm
    fi
done

### Additional package managers ###

# Flatpak
if [[ -f "/usr/bin/flatpak" ]]; then
    echo "flatpak is already installed."
else
    sudo pacman -S flatpak --noconfirm
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
