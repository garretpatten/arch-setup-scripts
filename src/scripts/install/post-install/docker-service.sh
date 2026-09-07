#!/bin/bash

command -v docker >/dev/null 2>&1 || exit 0
sudo systemctl enable docker.service 2>/dev/null || true
sudo systemctl start docker.service 2>/dev/null || true
sudo usermod -aG docker "$USER" 2>/dev/null || true
