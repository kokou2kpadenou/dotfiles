#!/bin/bash

# Create a folder to hold temporary screenshot image
mkdir ~/Pictures/i3lock_tmp

# Set image name
IMAGE=$HOME/Pictures/i3lock_tmp/screen.png

# Take a screenshot
scrot $IMAGE

# Set brightness and contrast
convert -brightness-contrast -30x-30 $IMAGE $IMAGE

# Add Gaussian blur and resize the image
convert -filter Gaussian -resize 25% -resize 400% $IMAGE $IMAGE

# Run i3lock with the screenshot as background image
i3lock -i $IMAGE --ignore-empty-password --show-failed-attempts --nofork

# Remove the temporary image
rm $IMAGE
