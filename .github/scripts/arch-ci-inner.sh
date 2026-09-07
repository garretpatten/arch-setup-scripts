#!/usr/bin/env bash
# Runs inside Docker (Arch). Workspace is bind-mounted at /workspace.
set -euo pipefail

mode="${1:-master}"

uid=$(stat -c '%u' /workspace)
gid=$(stat -c '%g' /workspace)

pacman -Syu --noconfirm
pacman -S --needed --noconfirm git sudo base-devel

# Ensure a UTF-8 locale is available; programs like btop fail without it.
if ! grep -q '^en_US.UTF-8 UTF-8' /etc/locale.gen; then
    echo 'en_US.UTF-8 UTF-8' >>/etc/locale.gen
fi
locale-gen
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

groupadd -g "$gid" runner 2>/dev/null || true
useradd -m -u "$uid" -g "$gid" runner 2>/dev/null || true
echo 'runner ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/runner
chmod 0440 /etc/sudoers.d/runner
chown -R runner:runner /workspace

# Build and install yay so AUR packages can be installed in CI.
if ! command -v yay >/dev/null 2>&1; then
    su -s /bin/bash runner -c \
        "cd /tmp && rm -rf yay && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm"
fi

# Ensure the runner can use Docker and start the daemon inside the privileged container.
usermod -aG docker runner 2>/dev/null || true
if command -v dockerd >/dev/null 2>&1; then
    dockerd >/tmp/dockerd.log 2>&1 &
    for _ in $(seq 1 30); do
        if [[ -S /var/run/docker.sock ]]; then
            chmod 666 /var/run/docker.sock
            break
        fi
        sleep 1
    done
fi

run_setup() {
    local script="$1"
    su -s /bin/bash runner -c \
        "export ARCH_SETUP_CI=1 LANG=${LANG} LC_ALL=${LC_ALL}; cd /workspace/src/scripts && bash ${script} || true"
}

run_validation() {
    local validator="$1"
    su -s /bin/bash runner -c \
        "export ARCH_SETUP_CI=${ARCH_SETUP_CI:-1} LANG=${LANG} LC_ALL=${LC_ALL}; sg docker -c 'cd /workspace && ./scripts/${validator}'"
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
