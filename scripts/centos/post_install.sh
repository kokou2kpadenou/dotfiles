#!/bin/sh

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# Color
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHTGRAY='\033[0;37m'
NC='\033[0m'  # No Color



### User input ###

# Get dotfiles folder name
dotfiles_dir=""
if [ $# -ge 1 ] && [ -n "$1" ]; then
  dotfiles_dir="$1"
  echo -e "the dotfiles folder is ${LIGHTGRAY}${dotfiles_dir}${NC}"
  echo "Enter to continue..."
  read
fi
default_dotfiles_dir="$HOME/.dotfiles"
if [ "$dotfiles_dir" = "" ]; then

  read -e -p "Dotfiles directory (defaut: ~/.dotfiles): " dotfiles_dir

  if [ "$dotfiles_dir" = "" ]; then
    dotfiles_dir=$default_dotfiles_dir
  fi
fi

# Set scripts folder name
scripts_dir="$dotfiles_dir/scripts"

# Get git global default username
git_name=""
while [ "$git_name" = "" ]; do
  read -p "Git global user name: " git_name
done

# Get git global default email
git_email=""
while [ "$git_email" = "" ]; do 
  read -p "Git global user email: " git_email
done

# Get git global default editor
git_editor=""
read -p "Git global editor (default vim): " git_editor
if [ "$git_editor" = "" ]; then
  git_editor=vim
fi


echo "Summary of inputs"
echo "-----------------"
echo
echo -e "Dotfiles location: ${LIGHTGRAY}$dotfiles_dir${NC}"
echo -e "Git Name: ${LIGHTGRAY}$git_name${NC}"
echo -e "Git Email: ${LIGHTGRAY}$git_email${NC}"
echo -e "Git Editor: ${LIGHTGRAY}$git_email${NC}"
echo
echo "Press enter to continue"

read


### Set up logging ###
exec 1> >(tee "~/Downloads/stdout.log")
exec 2> >(tee "~/Downloads/stderr.log")

### Installation of packages ###
# Activate development tools
sh ${scripts_dir}/centos/development_tools.sh

# installation of eepl repo
sh ${scripts_dir}/centos/add_eepl_repo.sh

# install neovim
sh ${scripts_dir}/centos/neovim.sh

# install application
sh ${scripts_dir}/centos/application.sh

# install Python
sh ${scripts_dir}/centos/python.sh

# install ruby
sh ${scripts_dir}/centos/ruby.sh

# install node
sh ${scripts_dir}/common/nvm_installer.sh

# NerdFonts DejaVuSansMono installation
sh ${scripts_dir}/common/fonts.sh "$dotfiles_dir"

# visual studio code installation
sh ${scripts_dir}/centos/vscode.sh

# chrome installation
sh ${scripts_dir}/centos/chrome.sh

# Symbolic Links Creation
ln -s -b ${dotfiles_dir}/gitignore_global ~/.gitignore_global
ln -s -b ${dotfiles_dir}/tmux.conf ~/.tmux.conf
ln -s -b ${dotfiles_dir}/nvim ~/.config/nvim

# Set Git Global setting
sh ${scripts_dir}/common/git.sh "$git_name" "$git_email" "$git_editor"

# Bach setting
sh ${scripts_dir}/common/bash_setting.sh

# Increase the limit of number of files to be watched by inotify
# To read
# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
sh ${scripts_dir}/common/nodejsENOSPCerrorFix.sh


### Clean up ###
# Applications packages cleanup
sudo dnf autoremove

# end messages
echo -e "${GREEN}Bravo!!!!!, The system is ready${NC}"

echo "Before continue, please stp setup GNOME Terminal"
echo "Font: DejaVuSansMono, Transparency: ~12%, Remove memu bar, Theme: dark"
echo "If ready press enter to continue."
read

echo "Enjoy!"
