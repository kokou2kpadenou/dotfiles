#!/bin/bash

entry=""

read -p "Dotfiles folder path (default: $HOME/.config/.dotfiles): " entry

if [ "$entry" = "" ]; then
  entry="$HOME/.config/.dotfiles"
fi

clear
cd ~
git clone --recurse-submodules https://github.com/kokou2kpadenou/dotfiles.git "$entry" && sh ${entry}/scripts/archlinux/post_install.sh
