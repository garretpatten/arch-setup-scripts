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

# Neovim config
mkdir -p "$HOME/.config/nvim/"
cp "$workingDirectory/src/dotfiles/nvim/init.vim" "$HOME/config/nvim/init.vim"

# Vim config
cp "$workingDirectory/src/dotfiles/vim/.vimrc" "$HOME/.vimrc"

### Runtimes ###

# Node.js
sudo pacman -S --noconfirm nodejs
sudo pacman -S --noconfirm npm

# Python
sudo pacman -S --noconfirm python3

### Frameworks ###

# Vue.js
if [[ -f "/usr/local/bin/vue" ]]; then
    echo "Vue is already installed."
else
    sudo npm install -g @vue/cli
fi

### Dev Tooling ###

# Docker and Docker-Compose
sudo pacman -S gnome-terminal --noconfirm
sudo pacman -S docker --noconfirm

sudo pacman -S docker-compose --noconfirm
docker image pull fedora
docker image pull ubuntu

# GitHub CLI
if [[ -f "/usr/local/bin/gh" ]]; then
    echo "gh is already installed."
else
    # TODO: Install GitHub CLI AUR package
    # https://archlinux.org/packages/extra/x86_64/github-cli/
fi

# Postman
yay -S --noconfirm postman-bin

# Semgrep
if [[ -f "$HOME/.local/bin/semgrep" ]]; then
    echo "Semgrep is already installed."
else
    sudo pacman -S python-semgrep --noconfirm
fi

# Shellcheck
sudo pacman -S shellcheck --noconfirm

# Sourcegraph
if [[ -f "/usr/local/bin/src" ]]; then
    echo "Sourcegraph CLI is already installed."
else
    curl -L https://sourcegraph.com/.api/src-cli/src_linux_amd64 -o "/usr/local/bin/src"
    chmod +x "/usr/local/bin/src"
fi

# VS Code
if [[ -f "/usr/bin/code" ]]; then
    echo "VS Code is already installed."
else
    sudo pacman -S --noconfirm code
    cp "$workingDirectory/src/config-files/vs-code/settings.json" "$HOME/.config/'Code - OSS'/User/settings.json"
fi

### Fonts ###

# Fira Code
if [[ -d "/usr/share/fonts/FiraCode/" ]]; then
    echo "Fira Code is already installed."
    if [[ "$packageManager" = "pacman" ]]; then
        cd "$HOME/Downloads" || return

        git clone https://aur.archlinux.org/ttf-firacode.git
        cd ttf-firacode || return
        makepkg -sri --noconfirm

        cd "$workingDirectory" || return
    fi
fi

### Package Managers ###

# Packer installation
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
"$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# Pip
if [[ -f "/usr/bin/pip" || -f "/usr/bin/python-pip" ]]; then
    echo "python-pip is already installed."
else
    sudo pacman -S --noconfirm python-pip
fi
