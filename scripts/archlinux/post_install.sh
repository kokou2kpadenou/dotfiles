#!/bin/bash

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# Color
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHTGRAY='\033[0;37m'
NC='\033[0m'  # No Color



### User input ###

# Get dotfiles folder name
dotfiles_dir="$1"
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

# Get node version 
node_ver=""
while [ "$node_ver" = "" ]; do
  read -p "Node version to install: " node_ver
done



echo
echo "Graphics Card (The output below shows the specific model)"
echo "---------------------------------------------------"
lspci -v | grep -A1 -e VGA -e 3D
echo ""

# Video Driver Selection
video_driver=""

PS3='Please select our video driver: '
options=("intel" "amd" "ati" "generic" "other")
select opt in "${options[@]}"
do
  case $opt in
    "intel")
      video_driver="xf86-video-intel"
      break
      ;;
    "amd")
      video_driver="xf86-video-amdgpu"
      break
      ;;
    "ati")
      video_driver="xf86-video-ati"
      break
      ;;
    "generic")
      break
      ;;
    "other")
      read -p "Diver Package Name: " video_driver
      break
      ;;
    *) echo -e "invalid option ${RED}$REPLY${NC}";;
  esac
done

clear

echo "Summary of inputs"
echo "-----------------"
echo
echo -e "Dotfiles location: ${LIGHTGRAY}$dotfiles_dir${NC}"
echo -e "Git Name: ${LIGHTGRAY}$git_name${NC}"
echo -e "Git Email: ${LIGHTGRAY}$git_email${NC}"
echo -e "Node version: ${LIGHTGRAY}$node_ver${NC}"
echo -e "Video Graphics driver: ${LIGHTGRAY}$video_driver${NC}"


# ### Set up logging ###
exec 1> >(tee "~/post_install/stdout.log")
exec 2> >(tee "~/post_install/stderr.log")



### Installation of packages ###

if [ "$video_driver" != "" ]; then 
  sudo pacman -S ${video_driver}
fi

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si PKGBUILD


sudo pacman -S --noconfirm reflector rsync

sudo reflector -c "United States" -a 6 --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syyuu && yay -Syyuu


sudo pacman -S --noconfirm xorg numlockx i3 xorg-xinit rxvt-unicode rofi ranger \
  feh w3m atool chromium firefox vlc openssh xss-lock gnome-screenshot \
  tmux inkscape gimp wget xsel

# # Installing Xorg packages, i3 and video drivers
# # sudo pacman -S nvidia nvidia-utils nvidia-settings xorg-server xorg-apps xorg-xinit i3 numlockx -noconfirm -needed

# Installing additional fonts (Optional) but highly recommended
sudo pacman -S --noconfirm noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont \
  ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font \
  ttf-font-awesome -noconfirm -needed

# # Installing sound drivers and tools
# sudo pacman -S alsa-utils alsa-plugins alsa-lib pavucontrol -noconfirm -needed
# # Installing additional tools for shell and ranger (Optional) but highly recommended
# # sudo pacman -S atool highlight browsh elinks mediainfo w3m ffmpegthumbnailer mupdf -noconfirm -needed
# 

sudo pacman -S --noconfirm neovim python python2 python-pip python2-pip ruby rubygems

python -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

gem install neovim

# Install node version manager, node 12 by defaut and neovim
sh ${scripts_dir}/common/nvm_installer.sh "$node_ver"

# NerdFonts DejaVuSansMono installation
sh ${scripts_dir}/fonts.sh "$dotfiles_dir"

ln -s -b ${dotfiles_dir}/i3 ~/.config/i3
ln -s -b ${dotfiles_dir}/nvim ~/.config/nvim
ln -s -b ${dotfiles_dir}/ranger ~/.config/ranger
ln -s -b ${dotfiles_dir}/rofi ~/.config/rofi
ln -s -b ${dotfiles_dir}/tmux.conf ~/.tmux.conf
ln -s -b ${dotfiles_dir}/.xinitrc ~/.xinitrc
ln -s -b ${dotfiles_dir}/.Xressources ~/.Xressources
ln -s -b ${dotfiles_dir}/gitconfig ~/.gitconfig
ln -s -b ${dotfiles_dir}/gitignore_global ~/.gitignore_global

# Git settings
sh ${scripts_dir}/common/git.sh "$git_name" "$git_email" "$git_editor"

# bash setup
sh ${scripts_dir}/common/bash_setting.sh "$dotfiles_dir"

# Increase the limit of number of files to be watched by inotify
sh ${scripts_dir}/common/nodejsENOSPCerrorFix.sh

echo -e "${GREEN}Bravo!!!!!"
