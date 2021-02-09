#!/bin/sh

#
# Script to deploy the dotfiles.
#

# Confirm the dotfiles directoy
dotfiles_dir="$DOTFILES"
default_dotfiles_dir="$HOME/.dotfiles"

git_name=""
git_email=""



if [ "$dotfiles_dir" = "" ]; then

  read -e -p "Dotfiles directory (defaut: ~/.dotfiles): " dotfiles_dir

  if [ "$dotfiles_dir" = "" ]; then
    dotfiles_dir=$default_dotfiles_dir
  fi
fi

while [ "$git_name" = "" ]; do
  read -p "Git name: " git_name
done

while [ "$git_email" = "" ]; do 
  read -p "Git email: " git_email
done


echo "$dotfiles_dir" "$git_name" "$git_email"

read

# Install GCC and Development Tools
sh ./development_tools.sh

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
sh ./fonts.sh "$dotfiles_dir"

# visual studio code installation
sh ./vscode.sh

# chrome installation
sh ./chrome.sh

# Symbolic Links Creation

ln -s -b ~/${dotfiles_dir}/gitconfig ~/.gitconfig

ln -s -b ~/${dotfiles_dir}/gitignore_global ~/.gitignore_global

ln -s -b ~/${dotfiles_dir}/tmux.conf ~/.tmux.conf

ln -s -b ~/${dotfiles_dir}/nvim ~/.config/nvim

#
# Set Git - name and email
#

git config --global user.name "$git_name"
git config --global user.email "$git_email"

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

# Change Gnome Terminal configution manually 
# - Font, transparency and remove menu bar
# - theme variant: Dark
# - uncheck show menubar
# TODO

echo "Before continue, please stp setup GNOME Terminal"
echo "Font: DejaVuSansMono, Transparency: ~12%, Remove memu bar, Theme: dark"
echo "If ready press enter to continue."
read

#
# End
#

# open neovim
nvim
