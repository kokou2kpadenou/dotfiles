#!/bin/bash

# Create a folder to hold temporary screenshot image
mkdir -p ~/Pictures/i3lock_tmp

# Set image name
IMAGE=$HOME/Pictures/i3lock_tmp/screen.png

# Take a screenshot
scrot $IMAGE

# Set brightness and contrast
magick $IMAGE -brightness-contrast -30x-30 $IMAGE


# Add Gaussian blur and resize the image
magick $IMAGE -blur 0x8 -resize 25% -resize 400% $IMAGE


# Run i3lock with the screenshot as background image
i3lock -i $IMAGE --ignore-empty-password --show-failed-attempts --nofork

# Remove the temporary image
rm $IMAGE
