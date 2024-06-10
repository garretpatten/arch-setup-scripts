#!/bin/bash

workingDirectory=$(pwd)

if [[ ! -f "/usr/bin/yay" ]]; then
    sudo pacman -S base-devel --nonconfirm
    sudo pacman -S git --noconfirm

    cd ~/Downloads || return
    git clone https://aur.archlinux.org/yay.git
    cd yay || return
    makepkg -sri --noconfirm

    cd "$workingDirectory" || return
fi

# Initial system update.
sudo pacman -Syu --noconfirm && yay -Yc --noconfirm

# Home directory customization.
sh "$workingDirectory/src/scripts/organizeHome.sh"

# Foundational CLI tooling.
sh "$workingDirectory/src/scripts/cli.sh"

# Security and privacy utilities.
bash "$workingDirectory/src/scripts/security.sh" "$workingDirectory"

# Productivity programs.
bash "$workingDirectory/src/scripts/productivity.sh" "$workingDirectory"

# Development environment setup.
bash "$workingDirectory/src/scripts/dev.sh" "$workingDirectory"

# Shell configuration.
zsh "$workingDirectory/src/scripts/shell.sh" "$workingDirectory"

# Penetration testing tools and wordlists.
bash "$workingDirectory/src/scripts/hacking.sh" "$workingDirectory"

# Streaming and video applications.
bash "$workingDirectory/src/scripts/media.sh"

# Final system update.
sudo pacman -Syu --noconfirm && yay -Yc --noconfirm

# Completion output.
# TODO: Move this to a postInstall.sh script

printf "\n\n============================================================================\n\n"

cat "$workingDirectory/src/assets/wolf.txt"

printf "\n\n============================================================================\n\n"

printf \
"Run the following to enable Docker daemon on startup:
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker %s
    newgrp docker\r" "$USER"

printf \
"\n\nRun the following to reload oh-my-zsh config:
    omz reload\r"

printf "\n\n============================================================================\n\n\r"

printf "Cheers -- system setup is now complete.\n\r"
