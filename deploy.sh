#!/bin/sh
#
# Script to deploy my vim dotfiles
#

# Plug.vim Installation
# Download plug.vim and put it in the "autoload" directory.
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Links
ln -s $PWD/ctags ~/.ctags
ln -s $PWD/vimrc ~/.vimrc
ln -s $PWD/tmux.conf ~/.tmux.conf
ln -s $PWD/gitconfig ~/.gitconfig

# Create undodir directory
mkdir ~/.vim/undodir -p

# Message
echo Please add the following line to your ~/.bash_profile
echo export TERM=xterm-256color

echo Make sure the following applications are installed 
sudo dnf install cmake
sudo dnf install python3-devel
