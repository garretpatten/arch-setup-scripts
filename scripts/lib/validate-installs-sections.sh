#!/usr/bin/env bash
# Shared install validation sections used by validate-installs*.sh.
# Sourcing scripts are expected to set PATH and source validate-common.sh first.

validate_preflight() {
    section 'Preflight'
    check_version curl curl --version
    check_version wget wget --version
}

validate_cli_packages() {
    section 'Packages'
    check_version bat bat --version
    check_version btop btop --force-utf --version
    check_version eza eza --version
    check_version fd fd --version
    check_version git git --version
    check_version htop htop --version
    check_version jq jq --version
    check_version fzf fzf --version
    check_version zoxide zoxide --version
    check_version whois whois --version
    check_version tldr tldr --version
    if [[ -d "$HOME/.cache/tealdeer/tldr-pages/pages.en" ]]; then
        check_path tldr-cache-en "$HOME/.cache/tealdeer/tldr-pages/pages.en"
    else
        pass tldr-cache-en 'not yet populated'
    fi
    check_version tree-sitter tree-sitter --version
    check_version pkg-config pkg-config --version
    check_pacman libsecret libsecret
    check_version lazygit lazygit --version
    check_version lazydocker lazydocker --version
    check_version ripgrep rg --version
    check_pacman unzip unzip
    check_version vim vim --version
    check_version wget wget --version
    check_version yazi yazi --version
    check_version fastfetch fastfetch --version
    check_version flatpak flatpak --version
}

validate_media() {
    section 'Media'
    check_version vlc vlc --version
    check_version ffmpeg ffmpeg -version
}

validate_productivity() {
    section 'Productivity'
    check_version libreoffice libreoffice --version
    check_pacman keepassxc keepassxc
    check_version flameshot flameshot --version
    check_command redshift redshift
    check_pacman zoom zoom
    check_version google-chrome google-chrome --version
    check_version bruno bruno --version
    check_pacman balena-etcher balena-etcher
}

validate_nvm() {
    section 'nvm'
    check_path nvm "$HOME/.nvm/nvm.sh"
}

validate_dev() {
    section 'Dev'
    check_version node node --version
    check_version npm npm --version
    check_version python3 python3 --version
    check_version go go version
    check_version ruby ruby --version
    if command -v rustc >/dev/null 2>&1; then
        check_version rustc rustc --version
        check_version cargo cargo --version
    else
        fail rustc 'rustup'
        fail cargo 'rustup'
    fi
    check_version php php --version
    check_version composer composer --version
    check_version java java --version
    check_version julia julia --version
    check_version lua lua -e 'print(_VERSION)'
    check_version luarocks luarocks --version
    check_version gcc gcc --version
    if command -v gem >/dev/null 2>&1 && gem list solargraph -i >/dev/null 2>&1; then
        pass solargraph-gem 'gem: solargraph'
    else
        fail solargraph-gem 'gem install --user-install solargraph'
    fi
    check_version docker docker --version
    check_version docker-compose docker compose version
    if docker info >/dev/null 2>&1; then
        pass docker-daemon 'docker info'
    else
        fail docker-daemon 'docker info'
    fi
    check_version neovim nvim --version
    check_version gh gh --version
    check_version shellcheck shellcheck --version
    if command -v semgrep >/dev/null 2>&1; then
        pass semgrep "$(version_of semgrep --version)"
    else
        fail semgrep 'pip user install (~/.local/bin/semgrep)'
    fi

    if command -v vue >/dev/null 2>&1; then
        pass vue-cli "$(version_of vue --version)"
    else
        fail vue-cli 'npm global @vue/cli'
    fi

    if command -v agent >/dev/null 2>&1; then
        pass cursor-agent "$(command -v agent)"
    elif command -v cursor-agent >/dev/null 2>&1; then
        pass cursor-agent "$(command -v cursor-agent)"
    else
        fail cursor-agent 'agent CLI (cursor.com/install)'
    fi

    check_command ollama ollama
    check_version lazygit lazygit --version
    check_version yazi yazi --version
}

validate_security_cli() {
    section 'Security'
    check_version nmap nmap --version
    check_version exiftool exiftool -ver
    check_version openvpn openvpn --version
    check_pacman ufw ufw
    check_command zaproxy zaproxy
    check_path ufw-docker /usr/local/bin/ufw-docker
    check_path hacking-payloads "$HOME/Hacking/PayloadsAllTheThings"
    check_path hacking-seclists "$HOME/Hacking/SecLists"

    if command -v protonpass >/dev/null 2>&1; then
        pass proton-pass-cli "$(command -v protonpass)"
    else
        fail proton-pass-cli '/usr/local/bin/protonpass'
    fi
}

validate_security_desktop() {
    section 'Security (desktop)'
    check_pacman signal-desktop signal-desktop
    check_pacman proton-pass-bin proton-pass-bin
    check_pacman proton-vpn-gtk-app proton-vpn-gtk-app
}

validate_shell() {
    section 'Shell'
    check_version zsh zsh --version
    check_version tmux tmux -V
    if command -v oh-my-posh >/dev/null 2>&1; then
        check_version oh-my-posh oh-my-posh --version
    elif [[ -x "${HOME}/.local/bin/oh-my-posh" ]]; then
        pass oh-my-posh "$("${HOME}/.local/bin/oh-my-posh" --version 2>/dev/null | head -n1)"
    else
        fail oh-my-posh 'oh-my-posh-bin (AUR)'
    fi
    check_pacman zsh-autosuggestions zsh-autosuggestions
    check_pacman zsh-syntax-highlighting zsh-syntax-highlighting
    check_pacman ttf-font-awesome ttf-font-awesome
    check_pacman ttf-fira-code ttf-fira-code
    check_pacman ttf-meslo-nerd ttf-meslo-nerd

    if command -v ghostty >/dev/null 2>&1; then
        pass ghostty "$(version_of ghostty --version)"
    else
        fail ghostty 'ghostty terminal'
    fi
}

validate_gnome() {
    section 'GNOME'
    check_pacman gnome-tweaks gnome-tweaks
    check_pacman gnome-shell-extensions gnome-shell-extensions
}
