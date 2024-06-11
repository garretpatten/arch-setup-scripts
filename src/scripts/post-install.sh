#!/bin/bash

workingDirectory=$1

printf "\n\n============================================================================\n\n"

cat "$workingDirectory/src/assets/wolf.txt"

printf "\n\n============================================================================\n\n"

printf \
"Run the following to enable Docker daemon on startup:
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker %s
    newgrp docker\r" "$USER"

printf "\n\n============================================================================\n\n\r"

printf "Cheers -- system setup is now complete.\n\r"

# Refresh shell
source "$HOME/.zshrc"