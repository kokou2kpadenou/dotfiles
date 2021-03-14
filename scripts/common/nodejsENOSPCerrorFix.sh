#!/bin/sh

# Delete the setting if it exists
sudo sed '/fs.inotify.max_user_watches/d' /etc/sysctl.conf

# Put the new setting
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
