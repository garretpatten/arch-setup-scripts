#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

sudo pacman -Syu --noconfirm 2>>"$ERROR_LOG_FILE" || true

essential_tools=(
    "git"
    "curl"
    "wget"
    "ca-certificates"
    "gnupg"
    "base-devel"
)
install_pacman_packages "${essential_tools[@]}"

if ! command -v yay >/dev/null 2>&1; then
    yay_build_dir="$TEMP_DIR/yay"
    rm -rf "$yay_build_dir" 2>/dev/null || true
    if clone_repository_safe "https://aur.archlinux.org/yay.git" "$yay_build_dir" && [[ -d "$yay_build_dir" ]]; then
        (cd "$yay_build_dir" && makepkg -sri --noconfirm 2>>"$ERROR_LOG_FILE") || log_error "Failed to build/install yay"
    fi
fi

if command -v yay >/dev/null 2>&1; then
    yay -Yc --noconfirm 2>>"$ERROR_LOG_FILE" || true
fi

if [[ "$(timedatectl show --property=Timezone --value 2>/dev/null)" == "UTC" ]]; then
    sudo timedatectl set-timezone America/New_York 2>>"$ERROR_LOG_FILE" || true
fi
