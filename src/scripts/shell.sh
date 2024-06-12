#!/bin/zsh

workingDirectory=$1

# Change root and user shell to zsh
if [[ -f "/usr/bin/zsh" ]]; then
    sudo chsh -s "$(which zsh)"
    chsh -s "$(which zsh)"
fi

### Install fonts ###

# Awesome Terminal Fonts
if [[ ! -d "/usr/share/fonts/awesome-terminal-fonts/" ]]; then
    sudo pacman -S awesome-terminal-fonts --noconfirm
fi

# Fira Code Fonts
if [[ ! -d "/usr/share/fonts/FiraCode/" ]]; then
    yay -S ttf-firacode --noconfirm
fi

# Powerline Fonts
if [[ ! -d "/usr/share/fonts/OTF/" ]]; then
    sudo pacman -S powerline-fonts --noconfirm
fi

### Install powerlevel10k ###
if [[ ! -f "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    yay -S zsh-theme-powerlevel10k-git --noconfirm
fi

### Zsh Plugins ###

# Zsh Autosuggestions
if [[ ! -d "/usr/share/zsh/plugins/zsh-autosuggestions/" ]]; then
    sudo pacman -S zsh-autosuggestions --noconfirm
fi

# Zsh Syntax Highlighting
if [[ ! -d "/usr/share/zsh/plugins/zsh-syntax-highlighting/" ]]; then
    sudo pacman -S zsh-syntax-highlighting --noconfirm
fi

### Terminal Configuration ###

# Configure Alacritty
if [[ ! -d "$HOME/.config/alacritty/" ]]; then
    mkdir -p "$HOME/.config/alacritty"
    git clone https://github.com/alacritty/alacritty-theme "$HOME/.config/alacritty/"
    touch "$HOME/.config/alacritty/alacritty.toml"
    cp "$workingDirectory/src/dotfiles/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

# Update ~/.zshrc
cp "$workingDirectory/src/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
