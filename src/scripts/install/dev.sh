#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

update_pacman_cache

node_packages=(
    "nodejs"
    "npm"
)
install_pacman_packages "${node_packages[@]}"

if [[ ! -d "$HOME/.nvm" ]]; then
    nvm_install_script="$TEMP_DIR/nvm_install.sh"
    download_file_safe "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh" "$nvm_install_script"
    bash "$nvm_install_script" 2>>"$ERROR_LOG_FILE" || true
fi

python_packages=(
    "python"
    "python-pip"
    "python-virtualenv"
)
install_pacman_packages "${python_packages[@]}"

sudo npm install -g @vue/cli --loglevel=error --no-update-notifier 2>>"$ERROR_LOG_FILE" || true

docker_packages=(
    "docker"
    "docker-compose"
)
install_pacman_packages "${docker_packages[@]}"

neovim_packages=(
    "neovim"
    "python-pynvim"
    "tree-sitter-cli"
)
install_pacman_packages "${neovim_packages[@]}"

dev_tools=(
    "github-cli"
    "shellcheck"
    "git"
)
install_pacman_packages "${dev_tools[@]}"

if command -v flatpak >/dev/null 2>&1 && flatpak remote-info flathub >/dev/null 2>&1; then
    flatpak install -y flathub com.getpostman.Postman 2>>"$ERROR_LOG_FILE" || true
fi

install_aur_packages "semgrep-bin"

sg_binary="$TEMP_DIR/sg"
download_file_safe "https://sourcegraph.com/.api/src-cli/src_linux_amd64" "$sg_binary"
if [[ -f "$sg_binary" ]]; then
    chmod +x "$sg_binary" 2>>"$ERROR_LOG_FILE" || true
    sudo mv "$sg_binary" /usr/local/bin/sg 2>>"$ERROR_LOG_FILE" || true
fi
