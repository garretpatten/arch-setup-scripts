# Arch Setup Scripts

A comprehensive collection of bash scripts for setting up Arch Linux development
environments with security tools, productivity applications, and system
configurations. These scripts are designed for reliable execution at scale
across Arch-based Linux distributions.

## ✨ Features

- **🔧 Automated Setup**: Complete system configuration with a single command
- **🛡️ Security First**: Built-in security tools, firewall configuration, and
  safe installation practices
- **⚡ Optimized Performance**: Batch installations and smart caching for
  faster execution
- **🔄 Idempotent**: Safe to run multiple times without issues
- **📝 Comprehensive Logging**: Detailed progress tracking and error reporting
- **🎯 Modular Design**: Run individual components or the complete setup

## 🚀 Quick Start

### Prerequisites

- Arch Linux or Arch-based distribution (EndeavourOS, Manjaro, etc.)
- Internet connection
- Sudo privileges

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/garretpatten/arch-setup-scripts
cd arch-setup-scripts
```

1. **Update submodules** (for dotfiles)

```bash
git submodule update --init --remote --recursive src/dotfiles/
```

1. **Make scripts executable**

```bash
chmod +x src/scripts/*.sh
```

1. **Run the complete setup**

```bash
./src/scripts/master.sh
```

### Individual Component Installation

You can also run individual setup scripts:

```bash
# Apply only desktop / system preferences (GNOME; Arch desktop session recommended)
./src/scripts/system-config.sh

# Install only development tools
./src/scripts/dev.sh

# Install only security tools
./src/scripts/security.sh

# Install only media applications
./src/scripts/media.sh
```

## 📋 What Gets Installed

### 🏠 **System Setup** (`organizeHome.sh`)

- Removes unused default directories (Music, Public, Templates)
- Creates organized project structure (Projects, Hacking, AppImages)
- Sets up development workspace with proper permissions

### ⚙️ **Desktop & system preferences** (`system-config.sh`)

- **GNOME (when a desktop session is available)**: Dark appearance, reduced UI
  animations, clock with date/weekday, optional battery percentage hidden
- **Input**: Classic (non-natural) scrolling for touchpad and mouse; fast key
  repeat
- **Files (Nautilus)**: Hidden files, list view, path in the location bar,
  tighter local search scope
- **Screenshots**: Save to `~/Pictures/Screenshots` (folder created if needed);
  no window shadow when supported
- **Dock**: Dash to Dock autohide with short delays (when extension installed)
- **Night Light**: Enabled with automatic schedule and warm temperature (pick
  **Night Light or Redshift** from `productivity.sh`, not both)
- **Session & lock**: Screen lock enabled; short delay before lock after idle
- **Privacy**: Fewer recent-file traces; old temp file cleanup
- **System (sudo)**: Guest login disabled via GDM when applicable; `logind`
  lid behavior; optional TCP keepalive sysctl tuning

Headless or minimal installs skip `gsettings` steps; run from a logged-in Arch
desktop session for full effect.

### 🛠️ **CLI Tools** (`cli.sh`)

- **Package Managers**: Flatpak with Flathub repository; `yay` for AUR
  (bootstrapped in `pre-install.sh`)
- **Essential Tools**: bat, curl, eza, fastfetch, fd, git, htop, jq, ripgrep,
  vim, wget

### 💻 **Development Environment** (`dev.sh`)

- **Languages**: Node.js + npm (official Arch repos), Python 3 + pip + virtualenv,
  NVM
- **Frameworks**: Vue.js CLI
- **Tools**: Docker, Docker Compose, GitHub CLI, Neovim (+ tree-sitter-cli),
  Postman (Flatpak), Semgrep, Shellcheck, Sourcegraph CLI
- **Configuration**: Git setup; dotfiles **`config/`** tree synced to
  `~/.config` (Neovim with lazy.nvim, terminals, etc.); `home/.vimrc` to
  `~/.vimrc` when absent

### 🎬 **Media Applications** (`media.sh`)

- **Browsers**: Brave Browser (AUR `brave-bin`)
- **Media Players**: VLC, Spotify (`spotify-launcher`)
- **Codecs**: FFmpeg, GStreamer plugins, Microsoft TrueType fonts (AUR
  `ttf-ms-fonts`)

### 📊 **Productivity Tools** (`productivity.sh`)

- **Office Suite**: LibreOffice with Breeze icons
- **Communication**: Zoom (AUR)
- **Note-taking**: Standard Notes (Flatpak)
- **Utilities**: Balena Etcher (AUR), Flameshot, KeePassXC, Redshift

### 🔒 **Security Tools** (`security.sh`)

- **Authentication**: Proton Pass (desktop AUR `proton-pass-bin` + CLI)
- **Defense**: UFW firewall, OpenVPN
- **VPN**: ProtonVPN GTK app with system tray integration
- **Communication**: Signal Messenger
- **Penetration Testing**: Nmap, OWASP ZAP, ExifTool
- **Resources**: PayloadsAllTheThings, SecLists repositories

### 🐚 **Shell & Terminal** (`shell.sh`)

- **Shells**: Zsh with autosuggestions and syntax highlighting
- **Terminal**: Ghostty (`ghostty` package) and Tmux multiplexer
- **Dotfiles**:
  - `src/dotfiles/config/*` is copied into `~/.config/` for each app (Ghostty,
    Neovim, Alacritty, Kitty, Zellij, Oh My Posh themes, etc.) only when that
    `~/.config/<app>` path does not already exist
  - **`home/`** files (`.zshrc`, `.tmux.conf`, optional `.bashrc`) are copied
    from `src/dotfiles/home/` when the target file in `$HOME` is missing
  - **`~/.dotfiles_path`** is written to point at `src/dotfiles` so
    `home/.zshrc` can resolve `DOTFILES` and source `home/zsh/arch.zsh`
- **Fonts**: Fira Code, Font Awesome, Powerline fonts, Meslo Nerd Font
- **Prompt**: Oh My Posh theme engine

## 🔧 System Configurations

The scripts automatically configure:

- **Desktop & session** (`system-config.sh`): GNOME preferences (appearance,
  input, Files, Dock, Night Light, lock/privacy) and related system defaults
- **Git**: User information and performance settings
- **Firewall**: UFW with secure defaults (deny incoming, allow outgoing)
- **Docker**: Service enablement and user group management
- **Shell**: Zsh as default with custom configurations
- **Terminal**: Ghostty, Tmux, and shell plugin setup
- **Timezone**: Set when still UTC (`pre-install.sh`)

## 📊 Monitoring & Logs

After installation, check:

- **Error Log**: `setup_errors.log` - Centralized error tracking
- **Console Output**: Real-time progress with color-coded messages

## ⚠️ Post-Installation Notes

1. **Restart Required**: Log out and back in for shell and group changes
1. **GNOME / desktop**: Some `system-config.sh` preferences apply fully after
   re-login or when running the script from an active desktop session
1. **Docker**: User added to docker group (logout required for effect)
1. **Firewall**: UFW enabled with SSH access allowed
1. **Night Light vs Redshift**: If you use GNOME Night Light from
   `system-config.sh`, disable or uninstall Redshift from `productivity.sh` to
   avoid conflicting color temperature
1. **Manual Setup**: Some applications (like Proton Pass, ProtonVPN) may
   require additional configuration

## 🔍 Troubleshooting

### Common Issues

**Script fails with permission errors:**

```bash
# Ensure scripts are executable
chmod +x src/scripts/*.sh
```

**Package installation fails:**

```bash
# Refresh package databases manually
sudo pacman -Syu
# Then re-run the script
```

**Docker commands require sudo:**

```bash
# Log out and back in, or run:
newgrp docker
```

**Shell doesn't change to Zsh:**

```bash
# Manually change shell
chsh -s $(which zsh)
# Then log out and back in
```

### Getting Help

- Check `setup_errors.log` for detailed error information
- Ensure you're running on a supported Arch-based distribution
- Verify internet connection for package downloads

## 🛡️ Security Features

- **GPG / signature verification** for AUR builds (via makepkg/yay)
- **Automatic firewall configuration** with secure defaults
- **Safe temporary file handling** with automatic cleanup
- **Principle of least privilege** for directory permissions

## Maintainers

[@garretpatten](https://github.com/garretpatten/)

_For questions, bug reports, or feature requests, please open an issue on this
repository or contact the maintainer directly._

## License

This project is licensed under the [MIT License](./LICENSE).
