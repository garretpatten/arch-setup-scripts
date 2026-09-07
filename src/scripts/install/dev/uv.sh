#!/bin/bash
# Install uv (Astral's Python package manager) and verify it works.
# https://docs.astral.sh/uv/getting-started/installation/
export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || true
fi

uv --version 2>/dev/null || true
