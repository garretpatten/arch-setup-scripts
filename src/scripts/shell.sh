#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

update_pacman_cache

dotfiles_root="$PROJECT_ROOT/src/dotfiles"
dotfiles_home_root="$dotfiles_root/home"

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

# Ghostty and other XDG configs under ~/.config are installed from src/dotfiles/config/ in dev.sh

tmux_config_file="$HOME/.tmux.conf"
tmux_source_file="$dotfiles_home_root/.tmux.conf"

if [[ ! -f "$tmux_config_file" && -f "$tmux_source_file" ]]; then
    copy_file_safe "$tmux_source_file" "$tmux_config_file"
fi

zsh_config_file="$HOME/.zshrc"
zsh_source_file="$dotfiles_home_root/.zshrc"

if [[ ! -f "$zsh_config_file" && -f "$zsh_source_file" ]]; then
    copy_file_safe "$zsh_source_file" "$zsh_config_file"
fi

# Keep the zsh DOTFILES cache in sync so home/.zshrc can source home/zsh/<os>.zsh.
if [[ -d "$dotfiles_home_root/zsh" ]]; then
    current_dotfiles_path=""
    if [[ -f "$HOME/.dotfiles_path" ]]; then
        IFS= read -r current_dotfiles_path <"$HOME/.dotfiles_path" || true
    fi
    if [[ "$current_dotfiles_path" != "$dotfiles_root" ]]; then
        printf '%s\n' "$dotfiles_root" >"$HOME/.dotfiles_path" 2>>"$ERROR_LOG_FILE" || true
    fi
fi

bashrc_config_file="$HOME/.bashrc"
bashrc_source_file="$dotfiles_home_root/.bashrc"
if [[ ! -f "$bashrc_config_file" && -f "$bashrc_source_file" ]]; then
    copy_file_safe "$bashrc_source_file" "$bashrc_config_file"
fi

# zsh_path
zsh_path="$(which zsh 2>/dev/null || echo "")"
if [[ -n "$zsh_path" && "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path" 2>/dev/null || true
fi
