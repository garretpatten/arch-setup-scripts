#!/bin/bash

# Snap is not native to Arch; prefer AUR/Flatpak alternatives or skip.

install_snap_if_missing() {
    echo "INFO: snap is not supported on Arch; skipping $1" >&2
    return 0
}

install_snaps_from_file() {
    local snaps_file="$1"
    local line snap_name

    if [[ ! -f "$snaps_file" ]]; then
        return 0
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// /}" ]] && continue

        read -r snap_name _ <<< "$line"
        install_snap_if_missing "$snap_name"
    done < "$snaps_file"
}
