#!/bin/sh

# prepare
sudo dnf install curl
# for the sake of running appimage:
sudo dnf install fuse-libs

# get appimage binary
sudo curl -o /usr/local/bin/nvim -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
# to get the nightly version instead:
# sudo curl -o /usr/local/bin/nvim -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage

# make it executable
sudo chmod a+x /usr/local/bin/nvim

