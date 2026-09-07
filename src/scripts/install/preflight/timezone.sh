#!/bin/bash
if [[ "$(timedatectl show --property=Timezone --value 2>/dev/null)" == "UTC" ]]; then
    sudo timedatectl set-timezone America/New_York 2>/dev/null || true
fi
