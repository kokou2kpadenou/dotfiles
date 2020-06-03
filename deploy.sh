#!/bin/sh
#
# Script to deploy the dotfiles.
#

# Plug.vim Installation
# Download plug.vim and put it in the "autoload" directory.
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Backup directory
mkdir ${PWD}/backup

# Symbolic Links Creation
list="ctags gitconfig gitignore_global vimrc tmux.conf"
echo "Creation of symbolic links: "

for l in ${list}
do
    f="${HOME}/.${l}"
    t="${PWD}/${l}"

    echo "- ${f}"

    if [ -L $f ]
    then
        old_t=`readlink $f`
        [ ! $old_t = $t ] && { rm $f && ln -s ${t} ${f} }
    fi
    # Do this if only the file exist and is not a link
    date=`date +%m%d%Y_%H%M%S%N`
    [ -f $f ] && { mv $f ${PWD}/backup/.${f}.${date} && ln -s ${t} ${f} }
done

# Create undodir directory
mkdir ~/.vim/undodir -p

# Set terminal Color
[ ! grep -q "export TERM=xterm-256color" "${HOME}/.bash_profile" ] && echo "export TERM=xterm-256color" >> "${HOME}/.bash_profile"
# Set terminal editor to vi
[ ! grep -q "set -o vi" "${HOME}/.bashrc" ] && echo "set -o vi" >> "${HOME}/.bashrc"

echo Make sure the following applications are installed 
sudo dnf install cmake
sudo dnf install python3-devel
