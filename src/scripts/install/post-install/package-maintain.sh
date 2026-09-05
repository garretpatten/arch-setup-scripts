#!/bin/bash

# shellcheck source=../../lib/package-maintain.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../lib/package-maintain.sh"

package_maintain_cleanup
