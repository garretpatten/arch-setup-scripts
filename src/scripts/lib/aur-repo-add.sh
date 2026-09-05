#!/bin/bash

# Arch/AUR repository helpers (no-op stubs where apt repo setup does not apply).
# Pacman repositories are configured in /etc/pacman.conf; AUR packages are installed via yay.

add_arch_repo_if_missing() {
    # Placeholder for explicit repo-line injection if ever needed.
    return 0
}

setup_repo_from_manifest_line() {
    # Arch does not use apt-style third-party repositories. AUR helpers and pacman
    # repos are handled elsewhere; this function exists to keep the manifest parser
    # interface consistent with the Ubuntu sibling.
    return 0
}
