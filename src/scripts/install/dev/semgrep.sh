#!/bin/bash
# Install semgrep via uv per https://docs.astral.sh/uv/guides/tools/
export PATH="${HOME}/.local/bin:${PATH}"
uv tool install semgrep 2>/dev/null || true
