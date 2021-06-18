#!/bin/bash

sudo pacman -Syu docker          # Install Docker
sudo pacman -Syu docker-compose  # Install docker-compose

# Start Docker on system startup
sudo systemctl enable --now docker

# Add your user to the `docker` group so you can use Docker without sudo
sudo usermod -a -G docker $(whoami)
