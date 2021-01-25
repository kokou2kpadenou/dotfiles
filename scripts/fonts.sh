#!/bin/sh

FONTS_INSTALL_PATH="/usr/share/fonts"
FONTS_TO_INSTALL_DIR="$HOME/.dotfiles/fonts/DejaVuSansMono"

sudo mv "$FONTS_TO_INSTALL_DIR" "$FONTS_INSTALL_PATH"

sudo fc-cache -f -v
