#!/bin/bash

workingDirectory=$1
dotfilesRoot=$(cd "$workingDirectory/src/dotfiles" && pwd)

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

if [[ ! -d "/usr/share/fonts/TTF/" ]]; then
    yay -S ttf-meslo-nerd --noconfirm
fi

# Powerline Fonts
if [[ ! -d "/usr/share/fonts/OTF/" ]]; then
    sudo pacman -S powerline-fonts --noconfirm
fi

### Install oh-my-posh ###
if [[ ! -f "/usr/bin/oh-my-posh" ]]; then
    yay -S oh-my-posh --noconfirm
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
fi
cp "$dotfilesRoot/config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# Oh My Posh themes (referenced from ~/.zshrc / OS fragments)
mkdir -p "$HOME/.config/oh-my-posh/themes"
cp -a "$dotfilesRoot/config/oh-my-posh/themes/." "$HOME/.config/oh-my-posh/themes/"

# Zellij
mkdir -p "$HOME/.config/zellij"
cp "$dotfilesRoot/config/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"

# Tmux
if [[ ! -f "$HOME/.tmux.conf" ]]; then
    cp "$dotfilesRoot/home/.tmux.conf" "$HOME/.tmux.conf"
fi

# Bash (optional; keeps same pattern as dotfiles repo)
if [[ ! -f "$HOME/.bashrc" ]]; then
    cp "$dotfilesRoot/home/.bashrc" "$HOME/.bashrc"
fi

# Primary zsh entry + cache DOTFILES so OS-specific fragments in home/zsh/ load
cp "$dotfilesRoot/home/.zshrc" "$HOME/.zshrc"
printf '%s\n' "$dotfilesRoot" > "$HOME/.dotfiles_path"
