#!/bin/bash

workingDirectory=$(pwd)

# Initial system update
sudo pacman -Syu --noconfirm && yay -Yc --noconfirm

# Home directory customization
sh "$workingDirectory/src/scripts/organizeHome.sh"

# CLI tools
sh "$workingDirectory/src/scripts/cli.sh"

# Browser
sh "$workingDirectory/src/scripts/web.sh"

# Security and privacy utilities
bash "$workingDirectory/src/scripts/security.sh" "$workingDirectory"

# Productivity programs
bash "$workingDirectory/src/scripts/productivity.sh" "$workingDirectory"

# Development environment setup
bash "$workingDirectory/src/scripts/dev.sh" "$workingDirectory"

# Shell configuration
zsh "$workingDirectory/src/scripts/shell.sh" "$workingDirectory"

# Penetration testing tools and wordlists
bash "$workingDirectory/src/scripts/hacking.sh" "$workingDirectory"

# Streaming and video applications
bash "$workingDirectory/src/scripts/media.sh"

# Final system update
sudo pacman -Syu --noconfirm && yay -Yc --noconfirm

bash "$workingDirectory/src/scripts/post-install.sh" "$workingDirectory"
