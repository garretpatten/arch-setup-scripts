#!/bin/bash

# Pacman/AUR repository batch helpers (Arch equivalent of apt PPAs).
# Pacman repos are usually pre-configured; AUR packages use yay.

add_pacman_repos_parallel() {
    # No-op: pacman repositories are managed via /etc/pacman.conf.
    return 0
}
