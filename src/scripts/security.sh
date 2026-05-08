#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/utils.sh"

update_pacman_cache

defense_tools=(
    "ufw"
    "openvpn"
)
install_pacman_packages "${defense_tools[@]}"

sudo ufw --force reset 2>>"$ERROR_LOG_FILE" || true
sudo ufw default deny incoming 2>>"$ERROR_LOG_FILE" || true
sudo ufw default allow outgoing 2>>"$ERROR_LOG_FILE" || true
sudo ufw allow ssh 2>>"$ERROR_LOG_FILE" || true
sudo ufw --force enable 2>>"$ERROR_LOG_FILE" || true

protonvpn_packages=(
    "proton-vpn-gtk-app"
    "libappindicator-gtk3"
    "gnome-shell-extension-appindicator"
)
install_aur_packages "${protonvpn_packages[@]}"

install_aur_packages "proton-pass-bin"

proton_pass_cli="$TEMP_DIR/proton-pass-cli"
proton_pass_cli_url=$(curl -s https://api.github.com/repos/protonpass/cli/releases/latest 2>>"$ERROR_LOG_FILE" | grep "browser_download_url.*linux-amd64" | cut -d '"' -f 4)
if [[ -n "$proton_pass_cli_url" ]]; then
    download_file_safe "$proton_pass_cli_url" "$proton_pass_cli"
    if [[ -f "$proton_pass_cli" ]] && [[ -s "$proton_pass_cli" ]]; then
        chmod +x "$proton_pass_cli" 2>>"$ERROR_LOG_FILE" || true
        sudo mv "$proton_pass_cli" /usr/local/bin/protonpass 2>>"$ERROR_LOG_FILE" || true
    fi
fi

install_pacman_packages "signal-desktop"

security_tools=(
    "nmap"
    "perl-image-exiftool"
    "zaproxy"
)
install_pacman_packages "${security_tools[@]}"

ensure_directory "$HOME/Hacking"

if [[ ! -d "$HOME/Hacking/PayloadsAllTheThings" ]]; then
    clone_repository_safe "https://github.com/swisskyrepo/PayloadsAllTheThings" "$HOME/Hacking/PayloadsAllTheThings"
fi

if [[ ! -d "$HOME/Hacking/SecLists" ]]; then
    clone_repository_safe "https://github.com/danielmiessler/SecLists" "$HOME/Hacking/SecLists"
fi
