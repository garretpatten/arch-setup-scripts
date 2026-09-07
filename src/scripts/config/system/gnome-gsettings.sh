#!/bin/bash

[[ "$OSTYPE" == linux-gnu* ]] || exit 0

# shellcheck source=../../lib/gnome-session.sh
source "$(dirname "$0")/../../lib/gnome-session.sh"
gnome_session_active || exit 0

command -v gsettings >/dev/null 2>&1 || exit 0
[[ -S "/run/user/$(id -u)/bus" ]] || exit 0
gsettings list-schemas 2>/dev/null | grep -qx org.gnome.desktop.interface || exit 0

gsettings set org.gnome.desktop.interface color-scheme prefer-dark 2>/dev/null || true
gsettings set org.gnome.desktop.interface enable-animations false 2>/dev/null || true
gsettings set org.gnome.desktop.interface clock-show-date true 2>/dev/null || true
gsettings set org.gnome.desktop.interface clock-show-weekday true 2>/dev/null || true
gsettings set org.gnome.desktop.interface clock-format 12h 2>/dev/null || true
gsettings set org.gnome.desktop.interface show-battery-percentage false 2>/dev/null || true

gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false 2>/dev/null || true
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false 2>/dev/null || true
gsettings set org.gnome.desktop.peripherals.keyboard delay 200 2>/dev/null || true
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 15 2>/dev/null || true

gsettings set org.gnome.nautilus.preferences show-hidden-files true 2>/dev/null || true
gsettings set org.gnome.nautilus.preferences show-image-thumbnails true 2>/dev/null || true
gsettings set org.gnome.nautilus.preferences default-folder-viewer list-view 2>/dev/null || true
gsettings set org.gnome.nautilus.preferences always-use-location-entry true 2>/dev/null || true
gsettings set org.gnome.nautilus.preferences recursive-search local-only 2>/dev/null || true

gsettings set org.gnome.gnome-screenshot auto-save-directory "file://${HOME}/Pictures/Screenshots" 2>/dev/null || true
gsettings set org.gnome.desktop.screenshots include-border false 2>/dev/null || true

if command -v gnome-extensions >/dev/null 2>&1; then
    gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null || true
fi

gsettings set org.gnome.desktop.search-providers disable-external false 2>/dev/null || true

if gsettings list-schemas 2>/dev/null | grep -qx org.gnome.settings-daemon.plugins.color; then
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 2700 2>/dev/null || true
fi

gsettings set org.gnome.desktop.screensaver lock-enabled true 2>/dev/null || true
gsettings set org.gnome.desktop.session idle-delay 600 2>/dev/null || true
gsettings set org.gnome.desktop.screensaver idle-activation-enabled true 2>/dev/null || true
gsettings set org.gnome.desktop.screensaver lock-delay 0 2>/dev/null || true

gsettings set org.gnome.desktop.privacy remember-recent-files false 2>/dev/null || true
gsettings set org.gnome.desktop.privacy remove-old-temp-files true 2>/dev/null || true
