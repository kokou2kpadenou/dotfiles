#!/bin/bash


set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR


# TODO: Problem with video card.
# lspci | grep -e VGA -e 3D
# sudo pacman -S xf86-video-intel
# sudo pacman -S xf86-video-amdgpu
# sudo pacman -S xf86-video-ati
# sudo pacman -S nvidia nvidia-utils nvidia-settings

video_driver=$(dialog --stdout --menu "Select video driver" 0 0 0 xf86-video-intel "intel" xf86-video-amdgpu "amd" xf86-video-ati "ati")
clear

### Set up logging ###
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

sudo pacman -S ${video_driver}

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si PKGBUILD


sudo pacman -S reflector rsync

sudo reflector -c "United States" -a 6 --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syyuu && yay -Syyuu


sudo pacman -S xorg numlockx i3 xorg-xinit rxvt-unicode rofi ranger \
  feh w3m atool chromium firefox vlc openssh xss-lock gnome-screenshot \
  tmux inkscape gimp wget curl xsel


# Installing Xorg packages, i3 and video drivers
# sudo pacman -S nvidia nvidia-utils nvidia-settings xorg-server xorg-apps xorg-xinit i3 numlockx -noconfirm -needed

# Installing additional fonts (Optional) but highly recommended
sudo pacman -S noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont \
  ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font \
  ttf-font-awesome -noconfirm -needed

# Installing sound drivers and tools
sudo pacman -S alsa-utils alsa-plugins alsa-lib pavucontrol -noconfirm -needed

# Installing additional tools for i3 productivity (Optional) but highly recommended
# sudo pacman -S rxvt-unicode ranger rofi conky dmenu urxvt-perls perl-anyevent-i3 perl-json-xs -noconfirm -needed

# Installing additional tools for shell and ranger (Optional) but highly recommended
# sudo pacman -S atool highlight browsh elinks mediainfo w3m ffmpegthumbnailer mupdf -noconfirm -needed


sudo pacman -S neovim python python2 python-pip python2-pip ruby rubygems
# nodejs-lts-erbium (node12) npm

python -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

gem install neovim

(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash) && \
  source ~/.bashrc && \
  nvm inatall 12.20.1 && \
  npm i -g neovim

cd ~
git clone https://github.com/kokou2kpadenou/dotfiles.git .dotfiles

sudo cp ~/.dotfiles/fonts/DejaVuSansMono /usr/share/fonts
sudo fc-cache -f -v

ln -s ~/.dotfiles/i3 ~/.config/i3
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/ranger ~/.config/ranger
ln -s ~/.dotfiles/rofi ~/.config/rofi
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.xinitrc ~/.xinitrc
ln -s ~/.dotfiles/.Xressources ~/.Xressources
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/gitignore_global ~/.gitignore_global

git config --global user.name "$git_name"
git config --global user.email "$git_email"


# Set terminal editor to vi
echo "set -o vi" >> ${HOME}/.bashrc

# Gruvbox
echo 'source "$HOME/.dotfiles/nvim/plugged/gruvbox/gruvbox_256palette.sh"' >> ${HOME}/.bashrc

# Increase the limit of number of files to be watched by inotify
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
