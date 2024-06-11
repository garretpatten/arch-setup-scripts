#!/bin/bash

cliTools=("alacritty" "bat" "curl" "exa" "eza" "fastfetch" "htop" "neovim" "openvpn" "terminator" "tmux" "vim" "wget" "zsh")
for cliTool in "${cliTools[@]}"; do
    if [[ ! -f "/usr/bin/$cliTool" ]]; then
        sudo pacman -S "$cliTool" --noconfirm
    fi
done

### Additional package managers ###

# Flatpak
if [[ ! -f "/usr/bin/flatpak" ]]; then
    sudo pacman -S flatpak --noconfirm
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
