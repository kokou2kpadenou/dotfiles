#!/bin/bash

# Set terminal editor to vi
echo "set -o vi" >> ${HOME}/.bashrc

echo "export DOTFILES=${1}" >> ${HOME}/.bashrc
echo "export EDITOR=vim" >> ${HOME}/.bashrc

# Aliases
cat <<EOT >> ${HOME}/.bashrc
# Aliases
if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi
EOT

echo "export PATH=$PATH:${1}/bin" >> ${HOME}/.bashrc
