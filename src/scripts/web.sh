#!/bin/bash

# Brave
if [[ -f "/usr/bin/brave-browser" ]]; then
    echo "Braver browser is already installed."
else
    yay -S --noconfirm brave-bin
fi
