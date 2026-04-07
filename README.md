# Arch Setup Scripts
- A repository of setup scripts for my personal arch linux environments

# Instructions

## How to Use
```
# Clone repository
git clone https://github.com/garretpatten/arch-setup-scripts

# Checkout repository
cd arch-setup-scripts

# Initialize and update submodules
git submodule init
git submodule update --remote --recursive

# Dotfiles: init nested submodules (taskwarrior themes, etc.)
( cd src/dotfiles && bash setup.sh )

# Return to the root of the project (if you changed directory)
cd "$(git rev-parse --show-toplevel)"

# Run master script
bash src/scripts/master.sh
```

# Installations

## CLI Tools and Terminal Applications
- base-devel
- bat
- clamav
- curl
- docker
- docker-compose
- exa
- fastfetch
- fd
- flatpak
- gh
- git
- htop
- imagemagick
- less
- man
- neovim
- nmap
- node
- npm
- openvpn
- ripgrep
- semgrep
- shellcheck
- src-cli
- task
- tmux
- ufw
- vim
- wget
- zsh

# Configurations
Dotfiles follow a **`config/`** (XDG app config) vs **`home/`** (e.g. `.zshrc`) layout; `master.sh` copies/symlinks targets and writes **`~/.dotfiles_path`** so `home/.zshrc` can source **`home/zsh/*.zsh`**.
- Alacritty, Oh My Posh themes, Zellij
- Git Credential Helper
- Home Directory
- Neovim (lazy.nvim)
- Taskwarrior
- Vim
- VS Code
- Z-shell

## Desktop Applications
- 1Password
- Alacritty
- Brave
- Burp Suite
- Postman
- Proton VPN
- Signl Messenger
- Sourcegraph
- Spotify
- Todoist
- VLC Media Player
- VS Code
- ZAProxy

# Other
- Blackarch Tools
- Hacking Wordlists
