#!/bin/bash

workingDirectory=$1
dotfilesRoot="$workingDirectory/src/dotfiles"

# Update ~/.vimrc
if [[ ! -f "$HOME/.vimrc" ]]; then
    cp "$dotfilesRoot/home/.vimrc" "$HOME/.vimrc"
fi

# Neovim (lazy.nvim bootstraps from config; sync tree-sitter CLI for plugins)
mkdir -p "$HOME/.config/nvim"
cp -a "$dotfilesRoot/config/nvim/." "$HOME/.config/nvim/"

if ! pacman -Qi tree-sitter-cli &>/dev/null; then
    sudo pacman -S tree-sitter-cli --noconfirm
fi

# Install plugin specs (lazy.nvim); safe to re-run
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
