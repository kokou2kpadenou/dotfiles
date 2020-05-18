#!/bin/sh
#
# Script to deploy my vim dotfiles
#

# Plug.vim Installation
# Download plug.vim and put it in the "autoload" directory.
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Links
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/tmux.conf ~/.tmux.conf
# ln -s ~/.vim/tmuxp ~/.tmuxp

# Create undodir directory
mkdir ~/.vim/undodir -p

# Create tmuxp directory
mkdir ~/.tmuxp

# Install tmuxp
pip3 install --user tmuxp

# Message
echo Please add the following line to your ~/.bash_profile
echo export TERM=xterm-256color

echo Make sure the following applications are installed 
