#!/bin/bash

# Set terminal editor to vi
echo "set -o vi" >> ${HOME}/.bashrc

# Aliases
cat <<EOT >> ${HOME}/.bashrc
# Aliases
if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi
EOT
