#!/bin/sh

find ~ -type f \( -name '*.swp' -o -name '*~' -o -name '*.bak' -o -name '.netrwhist' \) -delete
rm -rf /tmp/*

# List all node_modules found in a directory
find . -name "node_modules" -type d -prune | xargs du -chs

# Delete all node_modules found in a directory
find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
