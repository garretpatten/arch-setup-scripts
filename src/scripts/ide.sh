#!/bin/bash

workingDirectory=$1

# Update ~/.vimrc
if [[ ! -f "$HOME/.vimrc" ]]; then
    cp "$workingDirectory/src/dotfiles/vim/.vimrc" "$HOME/.vimrc"
fi

# Neovim setup
if [[ ! -f "$HOME/.config/nvim/init.vim" ]]; then
    mkdir -p "$HOME/.config/nvim/"
    cp "$workingDirectory/src/dotfiles/nvim/init.vim" "$HOME/config/nvim/init.vim"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
fi

# VS Code
if [[ ! -f "/usr/bin/code" ]]; then
    sudo pacman -S code --noconfirm
    code "$HOME"
    cp "$workingDirectory/src/dotfiles/vs-code/settings.json" "$HOME/.config/'Code - OSS'/User/settings.json"
fi
