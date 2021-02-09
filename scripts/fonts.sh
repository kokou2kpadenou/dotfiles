#!/bin/sh


dotfiles_dir_fonts="$1"
default_dotfiles_dir="$HOME/.dotfiles"

if [ "$1" = "" ]; then 
  read -e -p "Dotfiles dir (defaut: ~/.dotfiles): " dotfiles_dir_fonts

  if [$dotfiles_dir_fonts = ""]; then
    dotfiles_dir_fonts="$default_dotfiles_dir"
  fi
fi


FONTS_INSTALL_PATH="/usr/share/fonts"
FONTS_DIR="${dotfiles_dir_fonts}/fonts/DejaVuSansMono"

echo "$FONTS_DIR"

sudo mv "$FONTS_DIR" "$FONTS_INSTALL_PATH"

sudo fc-cache -f -v
