#!/bin/bash

# shellcheck source=../../lib/env.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../lib/env.sh"

install_dir="${HOME}/.local/bin"
install_script="$TEMP_DIR/oh-my-posh-install.sh"
mkdir -p "$install_dir"
curl -fsSL https://ohmyposh.dev/install.sh -o "$install_script" 2>/dev/null || exit 0
bash "$install_script" -d "$install_dir" 2>/dev/null || true

# Ensure themes directory is populated for prompt switching.
themes_dir="/usr/share/oh-my-posh/themes"
if [[ ! -d "$themes_dir" ]] || [[ -z "$(ls -A "$themes_dir" 2>/dev/null)" ]]; then
    sudo mkdir -p "$themes_dir" 2>/dev/null || true
    temp_repo_dir="$TEMP_DIR/oh-my-posh-repo"
    rm -rf "$temp_repo_dir" 2>/dev/null || true
    git clone --depth 1 https://github.com/JanDeDobbeleer/oh-my-posh.git "$temp_repo_dir" 2>/dev/null || true
    if [[ -d "$temp_repo_dir/themes" ]]; then
        sudo cp -r "$temp_repo_dir/themes/"* "$themes_dir/" 2>/dev/null || true
        sudo chmod -R 755 "$themes_dir" 2>/dev/null || true
        sudo chown -R root:root "$themes_dir" 2>/dev/null || true
    fi
fi
