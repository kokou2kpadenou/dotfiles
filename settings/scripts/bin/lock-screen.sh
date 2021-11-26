#!/bin/bash

IMAGES=(0 1 2 3 4 5)

WALLPAPER=~/Pictures/wallpapers/wallpaper.jpg
DEFAULT_WALLPAPER=~/Pictures/default_wallpapers/default${IMAGES[RANDOM%${#IMAGES[@]}]}.jpg

JPG=$(find "$WALLPAPER" -name *.jpg|head -n1)
[ ! -z "$JPG" ] && CURRENT_WALLPAPER="${WALLPAPER}" || CURRENT_WALLPAPERS="${DEFAULT_WALLPAPER}"

# convert ~/Pictures/wallpapers/wallpaper.jpg RGB:- | i3lock --raw 1800x1200:rgb --image /dev/stdin --ignore-empty-password --show-failed-attempts --nofork
convert $CURRENT_WALLPAPER RGB:- | i3lock --raw 1800x1200:rgb --image /dev/stdin --ignore-empty-password --show-failed-attempts --nofork
