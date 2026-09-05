#!/bin/bash

art="$PROJECT_ROOT/src/assets/arch.txt"
if [[ -f "$art" ]]; then
    echo
    echo "============================================================================"
    cat "$art" 2>/dev/null || true
    echo "============================================================================"
    echo
fi

echo "Setup completed."
