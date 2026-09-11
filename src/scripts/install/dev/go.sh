#!/bin/bash
# Ensure only the official Go gc toolchain is installed.
# https://wiki.archlinux.org/title/Go
sudo pacman -S --needed --noconfirm go 2>/dev/null || true
# Mark Go explicit so post-install dependency cleanup (yay -Yc) keeps it:
# when Go is pulled in only as an AUR build dependency, yay -Yc uninstalls it.
sudo pacman -D --asexplicit go 2>/dev/null || true
