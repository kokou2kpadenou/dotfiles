#!/bin/bash

WALLPAPERS=~/Pictures/wallpapers;
DEFAULT_WALLPAPERS=~/.dotfiles/wallpapers;


# First wallpaper before downloading image from google earthview
CURRENT_WALLPAPERS="${DEFAULT_WALLPAPERS}/*"
feh --bg-scale --randomize $CURRENT_WALLPAPERS


# Only procede when there is not existing process
NBOFPROCESS=$(pgrep -cx "auto_feh.sh")
if [ "$NBOFPROCESS" -eq 1 ]
then
  while true; do 

    # Check if i3 is running
    if pgrep -x "i3" > /dev/null
    then
      # i3 is running

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

      # Wallpaper will change every 30 minutes
      sleep 1800

    else
      # i3 is not running, exit the loop and the same time the process.
      break;
    fi

  done
fi
