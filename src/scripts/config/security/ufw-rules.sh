#!/bin/bash

command -v ufw >/dev/null 2>&1 || exit 0

# Allow nothing in, everything out
sudo ufw default deny incoming 2>/dev/null || true
sudo ufw default allow outgoing 2>/dev/null || true
sudo ufw allow ssh 2>/dev/null || true

# Allow ports for LocalSend
sudo ufw allow 53317/udp 2>/dev/null || true
sudo ufw allow 53317/tcp 2>/dev/null || true

# Allow Docker containers to use DNS on host
sudo ufw allow in proto udp from 172.16.0.0/12 to 172.17.0.1 port 53 comment 'allow-docker-dns' 2>/dev/null || true
sudo ufw allow in proto udp from 192.168.0.0/16 to 172.17.0.1 port 53 comment 'allow-docker-dns' 2>/dev/null || true

# Turn on the firewall
sudo ufw --force enable 2>/dev/null || true

# Enable UFW systemd service to start on boot
sudo systemctl enable ufw 2>/dev/null || true

# Turn on Docker protections
if command -v ufw-docker >/dev/null 2>&1; then
    sudo ufw-docker install 2>/dev/null || true
    sudo ufw reload 2>/dev/null || true
fi
