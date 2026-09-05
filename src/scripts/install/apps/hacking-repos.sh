#!/bin/bash
mkdir -p "$HOME/Hacking"
[[ -d "$HOME/Hacking/PayloadsAllTheThings" ]] || \
    git clone --depth 1 --filter=blob:none https://github.com/swisskyrepo/PayloadsAllTheThings "$HOME/Hacking/PayloadsAllTheThings" 2>/dev/null || true
[[ -d "$HOME/Hacking/SecLists" ]] || \
    git clone --depth 1 --filter=blob:none https://github.com/danielmiessler/SecLists "$HOME/Hacking/SecLists" 2>/dev/null || true
