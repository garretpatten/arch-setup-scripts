#!/bin/bash

# Initial system update
sudo pacman -Syu --noconfirm && yay -Yc --noconfirm

if [[ ! -f "/usr/bin/yay" ]]; then
    sudo pacman -S base-devel --nonconfirm
    sudo pacman -S git --noconfirm

    cd "$HOME/Downloads" || return
    git clone https://aur.archlinux.org/yay.git
    cd yay || return
    makepkg -sri --noconfirm

    cd "$workingDirectory" || return
fi
