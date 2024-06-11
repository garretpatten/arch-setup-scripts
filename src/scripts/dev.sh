#!/bin/bash

workingDirectory=$1

### Configuration ###

# Git config
# TODO: Copy over from dotfiles
if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global credential.helper store
    git config --global http.postBuffer 157286400
    git config --global pack.window 1
    git config --global user.email "garret.patten@proton.me"
    git config --global user.name "Garret Patten"
    git config --global pull.rebase false
fi

### Runtimes ###

# Node.js && npm
if [[ ! -f "/usr/bin/node" ]]; then
    sudo pacman -S nodejs --noconfirm
    sudo pacman -S npm --noconfirm
fi

# Python & pip
if [[ ! -f "/usr/bin/python" ]]; then
    sudo pacman -S python3 --noconfirm
    sudo pacman -S python-pip --noconfirm
fi

### Frameworks ###

# Vue.js
if [[ -f "/usr/local/bin/vue" ]]; then
    echo "Vue is already installed."
else
    sudo npm install -g @vue/cli
fi

### Dev Tools ###

# Docker and Docker-Compose
sudo pacman -S gnome-terminal --noconfirm
sudo pacman -S docker --noconfirm

sudo pacman -S docker-compose --noconfirm
docker image pull fedora
docker image pull kalilinux/kali-rolling

# GitHub CLI
if [[ ! -f "/usr/local/bin/gh" ]]; then
    yay -S github-cli-git --noconfirm
fi

# Postman
if [[ ! -f "/usr/bin/postman" ]]; then
    yay -S postman-bin --noconfirm
fi

# Semgrep
if [[ -f "$HOME/.local/bin/semgrep" ]]; then
    echo "Semgrep is already installed."
else
    sudo pacman -S python-semgrep --noconfirm
fi

# Shellcheck
sudo pacman -S shellcheck --noconfirm

# Sourcegraph
if [[ ! -f "/usr/local/bin/src" ]]; then
    curl -L https://sourcegraph.com/.api/src-cli/src_linux_amd64 -o "/usr/local/bin/src"
    chmod +x "/usr/local/bin/src"
fi
