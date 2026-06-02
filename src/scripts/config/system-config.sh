#!/bin/bash

# Arch Linux: desktop defaults (GNOME Shell when applicable) and system-wide settings.
# Hyprland and other Wayland compositors skip GNOME Shell-only gsettings; GTK/Nautilus
# preferences still apply when schemas exist. Run from a logged-in session for gsettings.

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$OSTYPE" != linux-gnu* ]]; then
    log_error "system-config.sh targets Linux (Arch)"
    exit 1
fi

ensure_directory "$HOME/Pictures/Screenshots"

if gsettings_ok; then
    gsettings_set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings_set org.gnome.desktop.interface enable-animations false
    gsettings_set org.gnome.desktop.interface clock-show-date true
    gsettings_set org.gnome.desktop.interface clock-show-weekday true
    gsettings_set org.gnome.desktop.interface clock-format 12h
    gsettings_set org.gnome.desktop.interface show-battery-percentage false

    gsettings_set org.gnome.desktop.peripherals.touchpad natural-scroll false
    gsettings_set org.gnome.desktop.peripherals.mouse natural-scroll false
    gsettings_set org.gnome.desktop.peripherals.keyboard delay 200
    gsettings_set org.gnome.desktop.peripherals.keyboard repeat-interval 15

    if gsettings_schema_exists org.gnome.nautilus.preferences; then
        gsettings_set org.gnome.nautilus.preferences show-hidden-files true
        gsettings_set org.gnome.nautilus.preferences show-image-thumbnails true
        gsettings_set org.gnome.nautilus.preferences default-folder-viewer list-view
        gsettings_set org.gnome.nautilus.preferences always-use-location-entry true
        gsettings_set org.gnome.nautilus.preferences recursive-search local-only
    fi

    if gsettings_schema_exists org.gnome.gnome-screenshot; then
        gsettings_set org.gnome.gnome-screenshot auto-save-directory "file://${HOME}/Pictures/Screenshots"
    fi
    if gsettings_schema_exists org.gnome.desktop.screenshots; then
        gsettings_set org.gnome.desktop.screenshots include-border false
    fi

    # GNOME Shell session settings — skip on Hyprland (use Redshift from install/productivity.sh).
    if desktop_is_gnome; then
        if gsettings_schema_exists org.gnome.shell.extensions.dash-to-dock; then
            gsettings_set org.gnome.shell.extensions.dash-to-dock autohide true
            gsettings_set org.gnome.shell.extensions.dash-to-dock autohide-delay 0.0
            gsettings_set org.gnome.shell.extensions.dash-to-dock animation-time 0.1
            gsettings_set org.gnome.shell.extensions.dash-to-dock dock-fixed false
        fi

        gsettings_set org.gnome.desktop.search-providers disable-external false

        if gsettings_schema_exists org.gnome.settings-daemon.plugins.color; then
            gsettings_set org.gnome.settings-daemon.plugins.color night-light-enabled true
            gsettings_set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
            gsettings_set org.gnome.settings-daemon.plugins.color night-light-temperature 2700
        fi

        gsettings_set org.gnome.desktop.screensaver lock-enabled true
        gsettings_set org.gnome.desktop.session idle-delay 600
        gsettings_set org.gnome.desktop.screensaver idle-activation-enabled true
        gsettings_set org.gnome.desktop.screensaver lock-delay 0

        gsettings_set org.gnome.desktop.privacy remember-recent-files false
        gsettings_set org.gnome.desktop.privacy remove-old-temp-files true
    fi
fi

sudo env ERROR_LOG_FILE="$ERROR_LOG_FILE" bash -c '
gdm_conf="/etc/gdm/custom.conf"
if [[ -f "$gdm_conf" ]] && ! grep -qE "^AllowGuest=false" "$gdm_conf" 2>/dev/null && grep -q "^\[daemon\]" "$gdm_conf" 2>/dev/null; then
    sed -i "/^\[daemon\]/a AllowGuest=false" "$gdm_conf" 2>>"$ERROR_LOG_FILE" || true
fi

sddm_conf="/etc/sddm.conf"
if [[ -f "$sddm_conf" ]] && ! grep -qE "^EnableGuest=false" "$sddm_conf" 2>/dev/null && grep -q "^\[General\]" "$sddm_conf" 2>/dev/null; then
    sed -i "/^\[General\]/a EnableGuest=false" "$sddm_conf" 2>>"$ERROR_LOG_FILE" || true
fi

sysctl_conf="/etc/sysctl.d/99-tcp-keepalive.conf"
if [[ ! -f "$sysctl_conf" ]]; then
    printf "%s\n" \
        "net.ipv4.tcp_keepalive_time = 600" \
        "net.ipv4.tcp_keepalive_intvl = 30" \
        "net.ipv4.tcp_keepalive_probes = 5" \
        >"$sysctl_conf"
fi
sysctl --system 2>>"$ERROR_LOG_FILE" || true
' || true

logind_dropin="/etc/systemd/logind.conf.d/50-lid.conf"
logind_dropin_created=0
if [[ ! -f "$logind_dropin" ]]; then
    sudo mkdir -p "$(dirname "$logind_dropin")" 2>>"$ERROR_LOG_FILE" || true
    if printf '%s\n' "[Login]" "HandleLidSwitch=suspend" "HandleLidSwitchExternalPower=suspend" "HandleLidSwitchDocked=ignore" |
        sudo tee "$logind_dropin" >/dev/null 2>>"$ERROR_LOG_FILE"; then
        logind_dropin_created=1
    fi
fi
# try-restart logind kicks graphical users off; only apply immediately when headless.
if [[ "$logind_dropin_created" -eq 1 ]] && ! graphical_login_active; then
    sudo systemctl try-restart systemd-logind.service 2>>"$ERROR_LOG_FILE" || true
fi
