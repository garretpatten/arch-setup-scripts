#!/bin/bash

workingDirectory=$1

### Authentication ###

# 1Password
if [[ -f "/usr/bin/1password" ]]; then
    echo "1Password is already installed."
else
    cd "$HOME/Downloads" || return

    # 1Password desktop app
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
    git clone https://aur.archlinux.org/1password.git
    cd 1password || return
    makepkg -sri --noconfirm

    # 1Password CLI
    ARCH="amd64" && \
    wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.23.0/op_linux_${ARCH}_v2.23.0.zip" -O op.zip && \
    unzip -d op op.zip && \
    sudo mv op/op /usr/local/bin && \
    rm -r op.zip op && \
    sudo groupadd -f onepassword-cli && \
    sudo chgrp onepassword-cli /usr/local/bin/op && \
    sudo chmod g+s /usr/local/bin/op

    cd "$workingDirectory" || return
fi

# TODO: Add hardware keys auth for system

### Defense ###

# Clam AV
if [[ -f "/usr/bin/clamscan" ]]; then
    echo "Clam Anti-Virus is already installed."
else
    sudo pacman -S clamav --noconfirm
fi

# Firewall
if [[ -f "/usr/sbin/ufw" ]]; then
    echo "Firewall is already installed."
else
    sudo pacman -S ufw --noconfirm
fi

sudo ufw enable

### Privacy ###

# Proton VPN, Proton VPN CLI, and system tray icon
if [[ -f "/usr/bin/protonvpn" ]]; then
    echo "Proton VPN is already installed."
else
    yay -S protonvpn --noconfirm
    sudo pacman -S libappindicator-gtk3 gnome-shell-extension-appindicator --noconfirm
fi

# Signal Messenger
if [[ -d "/usr/bin/signal-desktop" ]]; then
    echo "Signal is already installed."
else
    sudo pacman -S signal-desktop --noconfirm
fi
