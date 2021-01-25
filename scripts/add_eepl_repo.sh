#!/bin/sh

sudo dnf -y install dnf-plugins-core

sudo dnf install epel-release

#sudo dnf install 'dnf-command(config-manager)'

#sudo dnf config-manager --set-enabled PowerTools

sudo dnf update

