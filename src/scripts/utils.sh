#!/bin/bash

# Global configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 1
readonly SCRIPT_DIR
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)" || exit 1
readonly PROJECT_ROOT
readonly ERROR_LOG_FILE="${PROJECT_ROOT}/setup_errors.log"
readonly TEMP_DIR="/tmp/arch-setup-$$"

# Color codes for output formatting
readonly COLOR_RED='\033[0;31m'
readonly COLOR_NC='\033[0m' # No Color

# Log errors only
log_error() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_NC} $*" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*" >> "$ERROR_LOG_FILE"
}

# Install official Arch packages via pacman - multi-run safe
install_pacman_packages() {
    local packages=("$@")
    [[ ${#packages[@]} -eq 0 ]] && return 0
    sudo pacman -S --needed --noconfirm "${packages[@]}" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to install pacman packages: ${packages[*]}"
    }
}

# Install AUR packages via yay - multi-run safe
install_aur_packages() {
    local packages=("$@")
    [[ ${#packages[@]} -eq 0 ]] && return 0
    if ! command -v yay >/dev/null 2>&1; then
        log_error "yay is not installed; cannot install AUR packages: ${packages[*]}"
        return 1
    fi
    yay -S --needed --noconfirm "${packages[@]}" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to install AUR packages: ${packages[*]}"
    }
}

# Refresh pacman package database and upgrade
update_pacman_cache() {
    sudo pacman -Sy --noconfirm 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to refresh pacman database"
    }
}

# Create directory
ensure_directory() {
    mkdir -p "$1" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to create directory: $1"
    }
}

# Remove empty directory
remove_empty_directory() {
    rmdir "$1" 2>/dev/null || true
}

# Copy file
copy_file_safe() {
    local source="$1"
    local destination="$2"

    if [[ ! -f "$source" ]]; then
        log_error "Source file does not exist: $source"
        return
    fi

    mkdir -p "$(dirname "$destination")"
    cp "$source" "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to copy $source to $destination"
    }
}

# Download file
download_file_safe() {
    local url="$1"
    local destination="$2"

    curl -sSL --connect-timeout 30 --max-time 300 --fail --show-error "$url" -o "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to download $url"
        rm -f "$destination" 2>/dev/null || true
        return 1
    }

    if [[ ! -f "$destination" ]] || [[ ! -s "$destination" ]]; then
        log_error "Downloaded file is empty or missing: $destination"
        rm -f "$destination" 2>/dev/null || true
        return 1
    fi
}

# Clone git repository
clone_repository_safe() {
    local repo_url="$1"
    local destination="$2"
    local depth="${3:-}"

    if [[ -d "$destination" ]]; then
        return 0
    fi

    local clone_args=()
    if [[ -n "$depth" ]]; then
        clone_args+=("--depth" "$depth")
    fi

    git clone "${clone_args[@]}" "$repo_url" "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "Failed to clone repository $repo_url"
    }
}

# GNOME gsettings helpers — only when desktop schemas are installed (e.g. not on minimal/CI images).
gsettings_ok() {
    command -v gsettings >/dev/null 2>&1 || return 1
    [[ -S "/run/user/$(id -u)/bus" ]] || return 1
    gsettings list-schemas 2>/dev/null | grep -qx org.gnome.desktop.interface
}

gsettings_set() {
    gsettings set "$@" 2>>"$ERROR_LOG_FILE" || true
}

gsettings_schema_exists() {
    gsettings list-schemas 2>/dev/null | grep -qx "$1"
}

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Export functions and variables for use in other scripts
export -f log_error install_pacman_packages install_aur_packages update_pacman_cache
export -f ensure_directory remove_empty_directory copy_file_safe download_file_safe clone_repository_safe
export -f gsettings_ok gsettings_set gsettings_schema_exists
export PROJECT_ROOT SCRIPT_DIR ERROR_LOG_FILE TEMP_DIR
