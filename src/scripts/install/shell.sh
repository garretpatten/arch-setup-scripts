#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_pacman_cache

shell_packages=(
    "zsh"
    "tmux"
    "powerline"
    "powerline-fonts"
)
install_pacman_packages "${shell_packages[@]}"

install_pacman_packages "ghostty"

font_packages=(
    "ttf-font-awesome"
    "ttf-fira-code"
)
install_pacman_packages "${font_packages[@]}"

install_aur_packages "ttf-meslo-nerd"

fc-cache -fv 2>>"$ERROR_LOG_FILE" || true

plugin_packages=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)
install_pacman_packages "${plugin_packages[@]}"

install_aur_packages "oh-my-posh-bin"

themes_dir="/usr/share/oh-my-posh/themes"
if [[ ! -d "$themes_dir" ]] || [[ -z "$(ls -A "$themes_dir" 2>/dev/null)" ]]; then
    sudo mkdir -p "$themes_dir" 2>>"$ERROR_LOG_FILE" || true
    temp_repo_dir="$TEMP_DIR/oh-my-posh-repo"
    clone_repository_safe "https://github.com/JanDeDobbeleer/oh-my-posh.git" "$temp_repo_dir"
    if [[ -d "$temp_repo_dir/themes" ]]; then
        sudo cp -r "$temp_repo_dir/themes/"* "$themes_dir/" 2>>"$ERROR_LOG_FILE" || true
        sudo chmod -R 755 "$themes_dir" 2>>"$ERROR_LOG_FILE" || true
        sudo chown -R root:root "$themes_dir" 2>>"$ERROR_LOG_FILE" || true
    fi
fi
