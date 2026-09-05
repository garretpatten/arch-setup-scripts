#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/env.sh
source "$DIR/../lib/env.sh"
# shellcheck source=../lib/dotfiles-install.sh
source "$DIR/../lib/dotfiles-install.sh"

link_dotfiles_xdg_config_dirs
install_dotfiles_from_manifest "$DIR/dotfiles.manifest"

# Maintain ~/.dotfiles_path so home/.zshrc can source home/zsh/arch.zsh.
DOTFILES_ROOT="$PROJECT_ROOT/src/dotfiles"
if [[ -d "$DOTFILES_ROOT/home/zsh" ]]; then
    if [[ ! -f "$HOME/.dotfiles_path" ]]; then
        printf '%s\n' "$DOTFILES_ROOT" >"$HOME/.dotfiles_path" 2>/dev/null || true
    else
        existing_root=""
        IFS= read -r existing_root <"$HOME/.dotfiles_path" || true
        if [[ -z "$existing_root" ]] || [[ ! -d "$existing_root/home/zsh" ]]; then
            printf '%s\n' "$DOTFILES_ROOT" >"$HOME/.dotfiles_path" 2>/dev/null || true
        fi
    fi
fi
