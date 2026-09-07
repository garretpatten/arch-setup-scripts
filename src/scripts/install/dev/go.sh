#!/bin/bash
# Ensure only the official Go gc toolchain is installed.
# gcc-go provides a conflicting, older go binary and must not satisfy this step.
# https://wiki.archlinux.org/title/Go
sudo pacman -R --noconfirm gcc-go 2>/dev/null || true
sudo pacman -S --needed --noconfirm go 2>/dev/null || true
