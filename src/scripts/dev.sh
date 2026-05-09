#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

update_pacman_cache

dotfiles_root="$PROJECT_ROOT/src/dotfiles"
dotfiles_config_root="$dotfiles_root/config"
dotfiles_home_root="$dotfiles_root/home"

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

# Dotfiles: XDG app configs (Neovim lazy.nvim bootstraps in config/nvim/init.lua — no Packer)
xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
ensure_directory "$xdg_config_home"
if [[ -d "$dotfiles_config_root" ]]; then
    shopt -s dotglob nullglob
    for entry in "$dotfiles_config_root"/*; do
        [[ -e "$entry" ]] || continue
        name=$(basename "$entry")
        dest="$xdg_config_home/$name"
        if [[ ! -e "$dest" ]]; then
            cp -r "$entry" "$dest" 2>>"$ERROR_LOG_FILE" || true
        fi
    done
    shopt -u dotglob nullglob
fi

dev_tools=(
    "github-cli"
    "shellcheck"
    "git"
)
install_pacman_packages "${dev_tools[@]}"

if command -v flatpak >/dev/null 2>&1 && flatpak remote-info flathub >/dev/null 2>&1; then
    flatpak install -y flathub com.getpostman.Postman 2>>"$ERROR_LOG_FILE" || true
fi

install_pacman_packages "python-semgrep"

sg_binary="$TEMP_DIR/sg"
download_file_safe "https://sourcegraph.com/.api/src-cli/src_linux_amd64" "$sg_binary"
if [[ -f "$sg_binary" ]]; then
    chmod +x "$sg_binary" 2>>"$ERROR_LOG_FILE" || true
    sudo mv "$sg_binary" /usr/local/bin/sg 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global credential.helper store 2>>"$ERROR_LOG_FILE" || true
    git config --global http.postBuffer 157286400 2>>"$ERROR_LOG_FILE" || true
    git config --global pack.window 1 2>>"$ERROR_LOG_FILE" || true
    git config --global user.email "garret.patten@proton.me" 2>>"$ERROR_LOG_FILE" || true
    git config --global user.name "Garret Patten" 2>>"$ERROR_LOG_FILE" || true
    git config --global pull.rebase false 2>>"$ERROR_LOG_FILE" || true
    git config --global init.defaultBranch main 2>>"$ERROR_LOG_FILE" || true
fi

vim_config_file="$HOME/.vimrc"
vim_source_file="$dotfiles_home_root/.vimrc"
if [[ ! -f "$vim_config_file" && -f "$vim_source_file" ]]; then
    copy_file_safe "$vim_source_file" "$vim_config_file"
fi
