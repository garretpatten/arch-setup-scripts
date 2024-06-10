#!/bin/bash

workingDirectory=$1

# Brave
if [[ -f "/usr/bin/brave-browser" ]]; then
    echo "Braver browser is already installed."
else
    yay -S --noconfirm brave-bin
fi

# Notion
# TODO: Install Notion without using electron
if [[ -f "/usr/bin/notion-app" ]]; then
    echo "Notion is already installed."
else
    yay -S notion-app-electron --noconfirm
fi

# Taskwarrior
if [[ -f "/usr/bin/task" ]]; then
    echo "Taskwarrior is already installed."
else
    sudo pacman -S task --noconfirm

    # Handle first Taskwarrior prompt (to create config file).
    echo "yes" | task

    # Add manual setup tasks.
    task add Install Timeshift project:setup priority:H
    task add Remove unneeded update commands from .zshrc project:setup priority:H
    task add Take a snapshot of system project:setup priority:H
    task add Update .zshrc project:dev priority:H

    task add Sign into and sync Brave project:setup priority:M
    task add Configure 1Password project:setup priority:M

    task add Install Burp Suite project:setup priority:L
    task add Download needed files from Proton Drive project:setup priority:L
fi

# Taskwarrior config
cp "$workingDirectory/src/config-files/taskwarrior/taskrcUpdates.txt" "$HOME/.taskrc"

if [[ -d "$HOME/.task/themes/" ]]; then
    echo "Taskwarrior themes directory already exists."
else
    mkdir -p "$HOME/.task/themes/"

    # Add custom themes.
    cp -r "$workingDirectory/src/config-files/taskwarrior/themes/" "$HOME/.task/themes/"
fi

# Thunderbird
if [[ -f "/usr/bin/thunderbird" ]]; then
    echo "Thunderbird is already installed."
else
    sudo pacman -S --noconfirm thunderbird
fi

# Todoist
if [[ -f "/usr/bin/todoist" ]]; then
    echo "Todoist is already installed."
else
    cd "$HOME/AppImages" || return
    wget https://todoist.com/linux_app/appimage
    sudo mv appimage /usr/bin/todoist
    cd "$workingDirectory" || return
fi
