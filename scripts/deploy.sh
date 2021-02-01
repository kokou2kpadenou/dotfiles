#!/bin/sh

#
# Script to deploy the dotfiles.
#

# installation of eepl repo
sh ./add_eepl_repo.sh

# install neovim
sh ./nvim.sh

# install application
sh ./application.sh

# install Python
sh ./python.sh

# install ruby
sh ./ruby.sh

# install node
sh ./node.sh

# NerdFonts DejaVuSansMono installation
sh ./fonts.sh

# Change Gnome Terminal configution manually 
# - Font, transparency and remove menu bar
# - theme variant: Dark
# - uncheck show menubar
# TODO


# Symbolic Links Creation

ln -s -b ~/.dotfiles/gitconfig ~/.gitconfig

ln -s -b ~/.dotfiles/gitignore_global ~/.gitignore_global

ln -s -b ~/.dotfiles/tmux.conf ~/.tmux.conf

ln -s -b ~/.dotfiles/nvim ~/.config/nvim

#
# Set Environnement Variables
#

# Set terminal editor to vi
grep -q "set -o vi" "${HOME}/.bashrc" && echo "yes" || echo "set -o vi" >> ${HOME}/.bashrc


#
# Clean up
#

# Application package cleanup
sudo dnf autoremove

#
# Increase the limit of number of files to be watched by inotify
#

# To read
# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc

sh ./nodejsENOSPCerrorFix.sh


#
# End
#

# open neovim
nvim
