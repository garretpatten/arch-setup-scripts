#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/env.sh
source "$DIR/../lib/env.sh"
# shellcheck source=../lib/run.sh
source "$DIR/../lib/run.sh"
# shellcheck source=../lib/package-install.sh
source "$DIR/../lib/package-install.sh"
# shellcheck source=../lib/parallel.sh
source "$DIR/../lib/parallel.sh"

INSTALL_MODE="${1:-all}"
INSTALL_MODE="${INSTALL_MODE#-}"
INSTALL_MODE="${INSTALL_MODE#-}"

is_desktop() {
    [[ "$INSTALL_MODE" != cli ]]
}

PACKAGES=()
ASYNC_PIDS=()
AUR_PIDS=()

REPO_SCRIPTS=(
    repos/setup.sh
)

ASYNC_SCRIPTS=(
    dev/nvm.sh
    dev/rustup.sh
    dev/cursor-cli.sh
    dev/ollama.sh
    dev/semgrep.sh
    dev/ruby-gems.sh
    dev/vue-cli.sh
    shell/meslo-nerd-font.sh
    shell/oh-my-posh.sh
    apps/hacking-repos.sh
    apps/ufw-docker.sh
)

AUR_DESKTOP_SCRIPTS=(
    apps/chrome.sh
    apps/etcher.sh
    apps/proton-pass.sh
)

echo "==> Installing base packages..."
install_pacman_packages_from_file "$DIR/packages/base.packages"

echo "==> Installing shell packages..."
install_pacman_packages_from_file "$DIR/packages/shell.packages"

if is_desktop; then
    echo "==> Installing media packages..."
    install_pacman_packages_from_file "$DIR/packages/media.packages"

    echo "==> Installing desktop packages..."
    install_pacman_packages_from_file "$DIR/packages/desktop.packages"

    echo "==> Installing productivity packages..."
    install_pacman_packages_from_file "$DIR/packages/productivity.packages"
fi

echo "==> Setting up repositories..."
for script in "${REPO_SCRIPTS[@]}"; do
    run_script "$DIR/$script"
done

if is_desktop; then
    run_script "$DIR/apps/protonvpn-install.sh"
fi

echo "==> Reconciling shell packages..."
install_pacman_packages_from_file "$DIR/packages/shell.packages"

if is_desktop; then
    echo "==> Reconciling media packages..."
    install_pacman_packages_from_file "$DIR/packages/media.packages"

    echo "==> Reconciling desktop packages..."
    install_pacman_packages_from_file "$DIR/packages/desktop.packages"
fi

echo "==> Installing dev and language packages..."
install_pacman_packages_from_file "$DIR/packages/lsp.packages"
install_pacman_packages_from_file "$DIR/packages/dev.packages"

echo "==> Installing extra packages..."
install_pacman_packages_from_file "$DIR/packages/fastfetch.packages"
# lazydocker is AUR; lazygit and yazi are official.
install_pacman_packages_from_file "$DIR/packages/griffo.packages" optional
install_aur_packages lazydocker

if is_desktop; then
    install_pacman_packages_from_file "$DIR/packages/optional-desktop.packages" optional
fi

PACKAGES=()
if is_desktop; then
    append_packages_from_file "$DIR/packages/third-party-desktop.packages" PACKAGES
fi
append_packages_from_file "$DIR/packages/third-party-cli.packages" PACKAGES
if ! install_collected_pacman_packages optional; then
    install_collected_pacman_packages_individually optional
fi

install_pacman_packages_from_file "$DIR/packages/lsp-optional.packages" optional

run_script "$DIR/dev/git-credential-libsecret.sh"

echo "==> Initializing asynchronous downloads..."
for script in "${ASYNC_SCRIPTS[@]}"; do
    parallel_run_best_effort "$DIR/$script"
    ASYNC_PIDS+=("$!")
done
parallel_wait_pids_best_effort "asynchronous tasks" "${ASYNC_PIDS[@]}"
echo "==> Asynchronous tasks completed."

if is_desktop; then
    echo "==> Installing AUR desktop apps..."
    for script in "${AUR_DESKTOP_SCRIPTS[@]}"; do
        parallel_run_best_effort "$DIR/$script"
        AUR_PIDS+=("$!")
    done
    parallel_wait_pids_best_effort "AUR desktop apps" "${AUR_PIDS[@]}"

    # Brave and Bruno are AUR-only on Arch.
    install_aur_packages brave-bin bruno zoom zaproxy
fi

run_script "$DIR/apps/pass-cli.sh"
run_script "$DIR/apps/snaps.sh"

run_script "$DIR/post-install/all.sh"
