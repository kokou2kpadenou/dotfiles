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
echo -e "Video Graphics driver: ${LIGHTGRAY}$video_driver${NC}"


### Set up logging ###
exec 1> >(tee "~/Downloads/stdout.log")
exec 2> >(tee "~/Downloads/stderr.log")



### Installation of packages ###

if [ "$video_driver" != "" ]; then 
  sudo pacman -S --noconfirm ${video_driver}
fi

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si PKGBUILD
cd ~


sudo pacman -S --noconfirm reflector rsync

sudo reflector -c "United States" -a 6 --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syyuu --noconfirm && yay -Syyuu


sudo pacman -S --noconfirm xorg numlockx i3 xorg-xinit rxvt-unicode rofi ranger \
  feh w3m atool chromium firefox vlc openssh xss-lock gnome-screenshot \
  tmux inkscape gimp wget xsel alacritty picom papirus-icon-theme \
  gnome-calculator acpi bash-completion highlight

# # Installing Xorg packages, i3 and video drivers
# # sudo pacman -S nvidia nvidia-utils nvidia-settings xorg-server xorg-apps xorg-xinit i3 numlockx -noconfirm -needed

# Installing additional fonts
sudo pacman -S --noconfirm noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont \
  ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font \
  ttf-font-awesome

# # Installing sound drivers and tools
# sudo pacman -S alsa-utils alsa-plugins alsa-lib pavucontrol -noconfirm -needed
# # Installing additional tools for shell and ranger (Optional) but highly recommended
# # sudo pacman -S atool highlight browsh elinks mediainfo w3m ffmpegthumbnailer mupdf -noconfirm -needed
# 

yay -S visual-studio-code-bin

sudo pacman -S --noconfirm neovim python python2 python-pip python2-pip ruby rubygems

python -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

gem install neovim

# Install node version manager, node lts/erbium by defaut and neovim
sh ${scripts_dir}/common/nvm_installer.sh

# NerdFonts DejaVuSansMono installation
sh ${scripts_dir}/common/fonts.sh "$dotfiles_dir"

ln -s -b ${dotfiles_dir}/i3 ~/.config/i3
ln -s -b ${dotfiles_dir}/nvim ~/.config/nvim
ln -s -b ${dotfiles_dir}/ranger ~/.config/ranger
ln -s -b ${dotfiles_dir}/alacritty ~/.config/alacritty
ln -s -b ${dotfiles_dir}/picom ~/.config/picom
ln -s -b ${dotfiles_dir}/rofi ~/.config/rofi
ln -s -b ${dotfiles_dir}/tmux.conf ~/.tmux.conf
ln -s -b ${dotfiles_dir}/.xinitrc ~/.xinitrc
ln -s -b ${dotfiles_dir}/.Xresources ~/.Xresources
ln -s -b ${dotfiles_dir}/gitignore_global ~/.gitignore_global

# Git settings
sh ${scripts_dir}/common/git.sh "$git_name" "$git_email" "$git_editor"

# bash setup
sh ${scripts_dir}/common/bash_setting.sh "$dotfiles_dir"

# Increase the limit of number of files to be watched by inotify
sh ${scripts_dir}/common/nodejsENOSPCerrorFix.sh

echo -e "${GREEN}Bravo!!!!!, The system is ready${NC}"

echo "You can start x environment with startx."
