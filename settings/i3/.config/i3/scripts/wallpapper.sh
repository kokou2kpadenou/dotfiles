#!/bin/bash

WALLPAPERS=~/Pictures/wallpapers;
DEFAULT_WALLPAPERS=~/.dotfiles/wallpapers;

# if google image is downloaded then CURRENT_WALLPAPERS=WALLPAPERS
# Else CURRENT_WALLPAPERS=DEFAULT_WALLPAPERS
JPG=$(find "$WALLPAPERS" -name *.jpg|head -n1)
[ ! -z "$JPG" ] && CURRENT_WALLPAPERS="${WALLPAPERS}/*" || CURRENT_WALLPAPERS="${DEFAULT_WALLPAPERS}/*"

# Apply the wallpaper
feh --bg-scale --randomize $CURRENT_WALLPAPERS
