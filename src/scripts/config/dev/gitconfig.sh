#!/bin/bash

credential_helper="/usr/bin/git-credential-libsecret"
if [[ -x "$credential_helper" ]]; then
    git config --global credential.helper "$credential_helper" 2>/dev/null || true
fi

# Shared Git pre-commit hook (copied by config/dotfiles.sh)
if ! git config --global core.hooksPath >/dev/null 2>&1; then
    git config --global core.hooksPath "$HOME/.config/githooks" 2>/dev/null || true
fi

if [[ -f "$HOME/.gitconfig" ]]; then
    exit 0
fi

git config --global http.postBuffer 157286400 2>/dev/null || true
git config --global pack.window 1 2>/dev/null || true
git config --global user.email "garret.patten@proton.me" 2>/dev/null || true
git config --global user.name "Garret Patten" 2>/dev/null || true
git config --global pull.rebase false 2>/dev/null || true
git config --global init.defaultBranch main 2>/dev/null || true
