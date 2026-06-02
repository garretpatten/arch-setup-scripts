#!/bin/bash

# Global configuration — this file lives at src/scripts/utils.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 1
readonly SCRIPT_DIR
readonly SCRIPTS_DIR="$SCRIPT_DIR"
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

# Refresh pacman package database
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

# Copy file (skip if destination already exists — first-time provisioning only).
copy_file_safe() {
    local source="$1"
    local destination="$2"

    if [[ ! -f "$source" ]] || [[ -f "$destination" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$destination")"
    cp "$source" "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "failed to copy $source to $destination"
    }
}

# Copy directory tree when destination path does not already exist (idempotent provisioning).
copy_directory_safe() {
    local source="$1"
    local destination="$2"

    if [[ ! -d "$source" ]] || [[ -d "$destination" ]]; then
        return 0
    fi

    local dest_dir
    dest_dir=$(dirname "$destination")
    mkdir -p "$dest_dir"
    cp -r "$source" "$destination" 2>>"$ERROR_LOG_FILE" || {
        log_error "failed to copy directory $source to $destination"
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

# Active session: Hyprland (Wayland compositor; not GNOME Shell).
hyprland_session_active() {
    [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && return 0
    case ":${XDG_CURRENT_DESKTOP:-}:" in
        *:Hyprland:* | *:hyprland:*) return 0 ;;
    esac
    pgrep -x Hyprland >/dev/null 2>&1
}

# Active session: GNOME Shell (not Hyprland/Sway/etc.).
gnome_shell_session_active() {
    hyprland_session_active && return 1
    case ":${XDG_CURRENT_DESKTOP:-}:" in
        *:GNOME:*) return 0 ;;
    esac
    pgrep -x gnome-shell >/dev/null 2>&1
}

pacman_pkg_installed() {
    pacman -Q "$1" >/dev/null 2>&1
}

# gnome | hyprland | unknown — for install/config when session env is unavailable.
# Override with ARCH_SETUP_DESKTOP=gnome|hyprland.
setup_desktop_kind() {
    case "${ARCH_SETUP_DESKTOP:-auto}" in
        gnome | hyprland)
            printf '%s\n' "$ARCH_SETUP_DESKTOP"
            return 0
            ;;
    esac
    if hyprland_session_active; then
        printf 'hyprland\n'
        return 0
    fi
    if gnome_shell_session_active; then
        printf 'gnome\n'
        return 0
    fi
    if pacman_pkg_installed hyprland && ! pacman_pkg_installed gnome-shell; then
        printf 'hyprland\n'
        return 0
    fi
    if pacman_pkg_installed gnome-shell; then
        printf 'gnome\n'
        return 0
    fi
    printf 'unknown\n'
}

desktop_is_gnome() {
    [[ "$(setup_desktop_kind)" == gnome ]]
}

desktop_is_hyprland() {
    [[ "$(setup_desktop_kind)" == hyprland ]]
}

# True when a graphical login session is active. Restarting systemd-logind then
# terminates GNOME/Hyprland/Wayland sessions — avoid during desktop provisioning.
graphical_login_active() {
    if [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
        return 0
    fi
    case "${XDG_SESSION_TYPE:-}" in
        x11 | wayland) return 0 ;;
    esac
    if command -v loginctl >/dev/null 2>&1; then
        local sid stype
        while read -r sid _; do
            [[ -n "$sid" ]] || continue
            stype=$(loginctl show-session "$sid" -p Type --value 2>/dev/null) || continue
            case "$stype" in
                x11 | wayland) return 0 ;;
            esac
        done < <(loginctl list-sessions --no-legend 2>/dev/null)
    fi
    return 1
}

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Export functions and variables for use in other scripts
export -f log_error install_pacman_packages install_aur_packages update_pacman_cache
export -f ensure_directory remove_empty_directory
export -f copy_file_safe copy_directory_safe download_file_safe clone_repository_safe
export -f gsettings_ok gsettings_set gsettings_schema_exists
export -f hyprland_session_active gnome_shell_session_active setup_desktop_kind desktop_is_gnome desktop_is_hyprland
export -f graphical_login_active
export PROJECT_ROOT SCRIPT_DIR SCRIPTS_DIR ERROR_LOG_FILE TEMP_DIR
