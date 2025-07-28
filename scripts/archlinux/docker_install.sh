#!/bin/bash

# Packages installation
sudo pacman -Syu docker docker-compose docker-buildx

# Start Docker on system startup
sudo systemctl enable --now docker.service

# Add your user to the `docker` group so you can use Docker without sudo
sudo usermod -a -G docker $(whoami)

# create group docker
sudo newgrp docker
