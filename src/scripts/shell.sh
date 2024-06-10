#!/bin/bash

workingDirectory=$1

# Change user shells to zsh.
if [[ -f "/usr/bin/zsh" ]]; then
    chsh -s "$(which zsh)"
    sudo chsh -s "$(which zsh)"
fi

# Install nerdfonts
if [[ ! -f "/usr/share/fonts/TTF/MesloLGS-NF-Regular.ttf" ]]; then
    yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm
fi

# Install powerlevel10k
if [[ ! -f "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    yay -S zsh-theme-powerlevel10k-git --noconfirm
fi

# Install zsh plugins
if [[ ! -d "/usr/share/zsh/plugins/zsh-autosuggestions/" ]]; then
    sudo pacman -S zsh-autosuggestions --nonconfirm
elif [[ ! -d "/usr/share/zsh/plugins/zsh-syntax-highlighting" ]]; then
    sudo pacman -S zsh-syntax-highlighting --nonconfirm
fi

# Update ~/.zshrc
cp "$workingDirectory/src/dotfiles/zsh/.zshrc" "$HOME/.zshrc"

# Configure alacritty
mkdir -p "$HOME/.config/alacritty"
git clone https://github.com/alacritty/alacritty-theme "$HOME/.config/alacritty/"
touch "$HOME/.config/alacritty/alacritty.toml"
cp "$workingDirectory/src/dotfiles/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
