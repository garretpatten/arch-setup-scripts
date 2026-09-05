#!/bin/bash

credential_src="/usr/share/doc/git/contrib/credential/libsecret"
credential_bin="$credential_src/git-credential-libsecret"

if [[ ! -d "$credential_src" ]]; then
    credential_src="/usr/share/git/contrib/credential/libsecret"
    credential_bin="$credential_src/git-credential-libsecret"
fi

if [[ ! -d "$credential_src" ]]; then
    exit 0
fi

if [[ -x "$credential_bin" ]]; then
    exit 0
fi

if ! pacman -Q libsecret >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm libsecret 2>/dev/null || exit 0
fi

cd "$credential_src" || exit 0
sudo make 2>/dev/null || true

# Ensure a standard PATH binary name is available for credential.helper configs.
if [[ -x "$credential_bin" ]] && [[ ! -x /usr/bin/git-credential-libsecret ]]; then
    sudo install -m 755 "$credential_bin" /usr/bin/git-credential-libsecret 2>/dev/null || true
fi
