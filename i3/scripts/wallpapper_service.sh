#!/bin/bash

WALLPAPERS=~/Pictures/wallpapers;
DEFAULT_WALLPAPERS=~/.dotfiles/wallpapers;


# Remove the entire wallpapers directory for cleanup
rm -rf $WALLPAPERS

# And create new wallpapers directory
mkdir -p $WALLPAPERS

# Download a random google earthview image
wget -A jpg -m -p -E -k -K -np https://earthview.withgoogle.com -P $WALLPAPERS


# if google image is downloaded then CURRENT_WALLPAPERS=WALLPAPERS
# Else CURRENT_WALLPAPERS=DEFAULT_WALLPAPERS
JPG=$(find "$WALLPAPERS" -name *.jpg|head -n1)
[ ! -z "$JPG" ] && CURRENT_WALLPAPERS="${WALLPAPERS}/earthview.withgoogle.com/download/*" || CURRENT_WALLPAPERS="${DEFAULT_WALLPAPERS}/*"

# Apply the wallpaper
feh --bg-scale --randomize $CURRENT_WALLPAPERS

