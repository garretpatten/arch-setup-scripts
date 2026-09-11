#!/bin/bash

# git >= 2.55 ships a prebuilt credential helper; older installs have the
# source in the git contrib directory and must build it.
if [[ -x /usr/lib/git-core/git-credential-libsecret ]]; then
    if [[ ! -x /usr/bin/git-credential-libsecret ]]; then
        sudo ln -sf /usr/lib/git-core/git-credential-libsecret /usr/bin/git-credential-libsecret
    fi
    exit 0
fi

if ! pacman -Q libsecret >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm libsecret 2>/dev/null || exit 0
fi

credential_src=""
for candidate in \
    /usr/share/git/credential/libsecret \
    /usr/share/git/contrib/credential/libsecret \
    /usr/share/doc/git/contrib/credential/libsecret; do
    if [[ -d "$candidate" ]]; then
        credential_src="$candidate"
        break
    fi
done
if [[ -z "$credential_src" ]]; then
    exit 0
fi

credential_bin="$credential_src/git-credential-libsecret"
if [[ -x "$credential_bin" ]]; then
    exit 0
fi

cd "$credential_src" || exit 0
sudo make 2>/dev/null || true

# Ensure a standard PATH binary name is available for credential.helper configs.
if [[ -x "$credential_bin" ]] && [[ ! -x /usr/bin/git-credential-libsecret ]]; then
    sudo install -m 755 "$credential_bin" /usr/bin/git-credential-libsecret 2>/dev/null || true
fi
