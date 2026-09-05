#!/usr/bin/env bash
# Runs inside Docker (Arch). Workspace is bind-mounted at /workspace.
set -euo pipefail

mode="${1:-master}"

uid=$(stat -c '%u' /workspace)
gid=$(stat -c '%g' /workspace)

pacman -Syu --noconfirm
pacman -S --needed --noconfirm git sudo base-devel

groupadd -g "$gid" runner 2>/dev/null || true
useradd -m -u "$uid" -g "$gid" runner 2>/dev/null || true
echo 'runner ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/runner
chmod 0440 /etc/sudoers.d/runner
chown -R runner:runner /workspace

run_setup() {
    local script="$1"
    su -s /bin/bash runner -c \
        "export ARCH_SETUP_CI=1; cd /workspace/src/scripts && bash ${script} || true"
}

run_validation() {
    local validator="$1"
    su -s /bin/bash runner -c \
        "cd /workspace && ./scripts/${validator}"
}

case "$mode" in
    cli)
        run_setup 'run-install.sh cli'
        run_validation 'validate-installs-cli.sh'
        ;;
    config)
        run_setup 'run-config.sh'
        run_validation 'validate-config-only.sh'
        ;;
    all | full)
        run_setup 'run-install.sh all'
        run_validation 'validate-installs.sh'
        ;;
    master)
        run_setup 'master.sh'
        run_validation 'validate.sh'
        ;;
    *)
        echo "Usage: $0 {cli|config|all|master}" >&2
        exit 1
        ;;
esac
