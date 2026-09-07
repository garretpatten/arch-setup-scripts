#!/bin/bash

# Read package names from a file (one per line; # comments and blanks ignored) and install with pacman/yay.

append_packages_from_file() {
    local packages_file="$1"
    local array_name="${2:-PACKAGES}"
    local -n _packages_ref="$array_name"

    mapfile -t file_packages < <(grep -v '^#' "$packages_file" | grep -v '^[[:space:]]*$')
    if [[ ${#file_packages[@]} -eq 0 ]]; then
        return 0
    fi
    _packages_ref+=("${file_packages[@]}")
}

install_pacman_packages_individually() {
    local optional="${1:-}"
    shift
    local -a packages=("$@")
    local pkg

    for pkg in "${packages[@]}"; do
        if [[ "$optional" == optional ]]; then
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || true
        else
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || true
        fi
    done
}

install_pacman_packages_from_file() {
    local packages_file="$1"
    local optional="${2:-}"

    mapfile -t packages < <(grep -v '^#' "$packages_file" | grep -v '^[[:space:]]*$')
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi

    if [[ "$optional" == optional ]]; then
        if ! sudo pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null; then
            install_pacman_packages_individually optional "${packages[@]}"
        fi
        return 0
    fi

    if sudo pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null; then
        return 0
    fi

    install_pacman_packages_individually "" "${packages[@]}"
}

install_pacman_packages_from_files() {
    local optional="${1:-}"
    shift
    local packages_file
    local -a packages=()
    local -a file_packages=()

    for packages_file in "$@"; do
        mapfile -t file_packages < <(grep -v '^#' "$packages_file" | grep -v '^[[:space:]]*$')
        if [[ ${#file_packages[@]} -gt 0 ]]; then
            packages+=("${file_packages[@]}")
        fi
    done

    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi

    if [[ "$optional" == optional ]]; then
        if ! sudo pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null; then
            install_pacman_packages_individually optional "${packages[@]}"
        fi
        return 0
    fi

    if sudo pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null; then
        return 0
    fi

    for packages_file in "$@"; do
        install_pacman_packages_from_file "$packages_file"
    done
}

install_collected_pacman_packages() {
    local optional="${1:-}"

    # PACKAGES is populated by the install orchestrator before calling this helper.
    # shellcheck disable=SC2153,SC2154
    if [[ ${#PACKAGES[@]} -eq 0 ]]; then
        return 0
    fi

    if [[ "$optional" == optional ]]; then
        sudo pacman -S --needed --noconfirm "${PACKAGES[@]}" 2>/dev/null || return 1
    else
        sudo pacman -S --needed --noconfirm "${PACKAGES[@]}" 2>/dev/null
    fi
}

# Install each package separately so one unavailable package does not block the rest.
install_collected_pacman_packages_individually() {
    local optional="${1:-}"
    local pkg

    # shellcheck disable=SC2153,SC2154
    for pkg in "${PACKAGES[@]}"; do
        if [[ "$optional" == optional ]]; then
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || true
        else
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || true
        fi
    done
}

install_aur_packages() {
    local -a packages=("$@")
    [[ ${#packages[@]} -eq 0 ]] && return 0
    if ! command -v yay >/dev/null 2>&1; then
        echo "WARNING: yay is not installed; skipping AUR packages: ${packages[*]}" >&2
        return 1
    fi
    yay -S --needed --noconfirm "${packages[@]}" 2>/dev/null || {
        echo "WARNING: Failed to install AUR packages: ${packages[*]}" >&2
        return 1
    }
}

install_aur_packages_from_file() {
    local packages_file="$1"

    mapfile -t packages < <(grep -v '^#' "$packages_file" | grep -v '^[[:space:]]*$')
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi

    install_aur_packages "${packages[@]}"
}
