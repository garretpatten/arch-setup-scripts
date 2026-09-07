#!/bin/bash
# Ensure only the official Go gc toolchain is installed.
# https://wiki.archlinux.org/title/Go
sudo pacman -S --needed --noconfirm go 2>/dev/null || true
