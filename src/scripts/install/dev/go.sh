#!/bin/bash
# The official go toolchain conflicts with gcc-go on Arch.
sudo pacman -R --noconfirm gcc-go 2>/dev/null || true
sudo pacman -S --needed --noconfirm go 2>/dev/null || true
