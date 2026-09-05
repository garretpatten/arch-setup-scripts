#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/snap-install.sh
source "$DIR/../../lib/snap-install.sh"

# Snap is not native to Arch; AUR/Flatpak alternatives are installed elsewhere.
# This script keeps parity with the Ubuntu tree and no-ops on Arch.
install_snaps_from_file "$DIR/../snaps.txt"
