#!/bin/bash

while true; do 
  feh --bg-scale --randomize ~/wallpapers/*
  sleep 1800
done

# watch -n 120 "feh --bg-scale --randomize ~/wallpapers/*" >> ~/.feh.log 2>&1 &

# Delete files older than 1 Hour
# find /path/to/files* -mmin +60 -exec rm {} \;

# Delete files modified in the last 30 minutes
# find /path/to/files* -type f -mmin 30 -exec rm {} \;

# wget -A jpg -m -p -E -k -K -np https://earthview.withgoogle.com
