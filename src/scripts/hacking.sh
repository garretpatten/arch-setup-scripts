#!/bin/bash

workingDirectory=$1

### Payloads ###

# Payloads All the Things
git clone https://github.com/swisskyrepo/PayloadsAllTheThings "$HOME/Hacking/"

# SecLists
git clone https://github.com/danielmiessler/SecLists "$HOME/Hacking/"

### Tools ###

# Black Arch tools
cd "$HOME/Hacking/" || return
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
cd "$workingDirectory" || return

# Burp Suite
if [[ -f "/usr/bin/burpsuite" ]]; then
    echo "Burp Suite is already installed."
else
    cd "$HOME/AUR/" || return

    git clone https://aur.archlinux.org/burpsuite.git
    cd burpsuite || return
    makepkg -sri --noconfirm

    cd "$workingDirectory" || return
fi

# Network Mapper
if [[ -f "/usr/bin/nmap" ]]; then
    echo "Network Mapper is already installed."
else
    sudo pacman -S nmap --noconfirm
fi

# ZAP
sudo pacman -S zaproxy --noconfirm
