#!/bin/sh

entry=""

read -p "Install directoy (default: ~/.dotfiles): " entry

if [ "$entry" = "" ]; then 
  entry="~/.dotfiles"
fi


if [[ ! -d "$DOTFILES" ]]; then 
  export DOTFILES="${entry}"
  # if grep -qF "export DOTFILES="${entry}"" ~/.bashrc; then
  #   echo "exists"
  # else
  #   echo "export DOTFILES="${entry}"" >> ~/.bashrc
  # fi
fi

git clone https://github.com/kokou2kpadenou/dotfiles.git "$DOTFILES"

sh ${DOTFILES}/scripts/deploy.sh