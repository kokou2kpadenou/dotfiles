#!/bin/sh

entry=""

read -p "Clone name (default: .dotfiles): " entry

if [ "$entry" = "" ]; then 
  entry=".dotfiles"
fi

git clone https://github.com/kokou2kpadenou/dotfiles.git "$entry" && pwd
