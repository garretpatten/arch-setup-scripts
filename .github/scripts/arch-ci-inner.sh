#!/usr/bin/env bash
# Runs inside Docker (Arch). Workspace is bind-mounted at /workspace.
set -euo pipefail

uid=$(stat -c '%u' /workspace)
gid=$(stat -c '%g' /workspace)

pacman -Syu --noconfirm
pacman -S --needed --noconfirm git sudo base-devel

groupadd -g "$gid" runner 2>/dev/null || true
useradd -m -u "$uid" -g "$gid" runner 2>/dev/null || true
echo 'runner ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/runner
chmod 0440 /etc/sudoers.d/runner
chown -R runner:runner /workspace

su -s /bin/bash runner -c 'cd /workspace/src/scripts && bash master.sh || true'
