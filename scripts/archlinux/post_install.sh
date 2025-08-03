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
default_dotfiles_dir="$HOME/.config/.dotfiles"
if [ "$dotfiles_dir" = "" ]; then

  read -e -p "Dotfiles directory (defaut: ~/.config/.dotfiles): " dotfiles_dir

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
echo -e "Git User Name: ${LIGHTGRAY}$git_name${NC}"
echo -e "Git Email: ${LIGHTGRAY}$git_email${NC}"
echo -e "Video Graphics driver: ${LIGHTGRAY}$video_driver${NC}"
echo
echo "Press enter to continue"

read


### Set up logging ###
exec 1>/tmp/arch_post_installation.log 2>&1



### Installation of packages ###

## Installation of yay
cd ~/Downloads && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ~ && rm -rf ~/Downloads/yay

## Update / Upgrade packages
sudo pacman -S --noconfirm reflector rsync

sudo reflector -c "United States" -a 6 --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syu --noconfirm && yay -Syu

# Packages list
PACKAGES=(

  # --- System / Shell Utilities ---
  acpi                 # Power management info
  stow                 # Dotfile management via symlinks
  wget                 # Download files from web
  which                # Show full path of shell commands
  tree                 # Directory listing in tree format
  jq                   # JSON processor
  starship             # Minimal, customizable shell prompt
  zsh                  # Zsh shell
  hugo                 # Static site generator
  atac                 # Custom package or unknown utility
  tokei                # Count lines of code (better cloc)

  # --- Terminal + Multiplexer ---
  rxvt-unicode         # Lightweight terminal emulator
  alacritty            # GPU-accelerated terminal emulator
  tmux                 # Terminal multiplexer

  # --- Fonts / Themes ---
  ttf-dejavu-nerd      # Nerd font (icons and dev symbols)
  ttf-ubuntu-font-family # Ubuntu font family
  papirus-icon-theme   # Icon theme

  # --- Xorg / Graphical Session ---
  xorg                 # X Window System
  xorg-xinit           # To start X sessions manually
  numlockx             # Enable num lock on start
  picom                # Compositor for transparency and shadows
  xss-lock             # Locks screen on suspend/idle
  feh                  # Lightweight image viewer, also for wallpapers

  # --- Window Manager & Tools ---
  i3                   # Tiling window manager
  rofi                 # App launcher / window switcher
  dunst                # Lightweight notification daemon
  gnome-screenshot     # Screenshot utility
  scrot                # CLI screenshot tool
  gnome-calculator     # Graphical calculator

  # --- Sound ---
  alsa-utils           # ALSA sound system utilities
  alsa-plugins         # ALSA plugins
  alsa-lib             # ALSA library
  pavucontrol          # PulseAudio volume control GUI

  # --- Clipboard / Selection ---
  xsel                 # Access X clipboard from terminal

  # --- Networking / Remote ---
  openssh              # SSH client and tools

  # --- Command-line Tools / Search ---
  fzf                  # Fuzzy finder
  ripgrep              # Fast grep alternative
  fd                   # Fast alternative to `find`
  lazygit              # TUI Git interface
  highlight            # Source code highlighting
  atool                # Archive manager (wrapper for other tools)
  w3m                  # Text-based web browser (can view images in terminal)

  # --- Graphics / Media ---
  gimp                 # Image editor
  inkscape             # Vector graphics editor

  )

# Add video driver packages
if [ "$video_driver" != "" ]; then
  PACKAGES+=("$video_driver")
fi



echo "🔍 Checking package list..."

for pkg in "${PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "✔ $pkg is already installed."
  elif pacman -Si "$pkg" &>/dev/null; then
    echo "➕ $pkg is valid and not installed. Marking for install."
    MISSING+=("$pkg")
  else
    echo "❌ $pkg does not exist in official repos. Skipping."
    INVALID+=("$pkg")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "📦 Installing packages: ${MISSING[*]}"
  pacman -Sy --noconfirm "${MISSING[@]}"
  # printf "%s\n" "${MISSING[@]}" >> "$LOG_FILE"
  # echo "✅ Installed ${#MISSING[@]} package(s). Logged to $LOG_FILE"
else
  echo "✅ No new packages to install."
fi

if [[ ${#INVALID[@]} -gt 0 ]]; then
  echo "⚠️  Warning: ${#INVALID[@]} invalid package(s) were skipped:"
  printf "   - %s\n" "${INVALID[@]}"
fi


yay -S visual-studio-code-bin google-chrome zen-browser-bin vscodium-bin

# Installation of Docker and Docker-compose
sh ${scripts_dir}/archlinux/docker_install.sh

# create user systemd folder if it is not existed.
# mkdir -p ~/.config/systemd/user

# Create the symbolic links
CONFIGS=(
  alacritty
  # alert_battery # Only set on laptop
  default_wallpapers
  dunst
  git
  i3
  lock-screen
  picom
  rofi
  starship
  stow
  tmux
  vim-minimal
  xinitrc
  xresources
  zlogout
  zshenv
  )

cd ${dotfiles_dir}/settings && stow --target=$HOME -S "${CONFIGS[@]}"

cd ~
#
# Git settings
sh ${scripts_dir}/common/git.sh "$git_name" "$git_email"

# Increase the limit of number of files to be watched by inotify
sh ${scripts_dir}/common/nodejsENOSPCerrorFix.sh

# Active zsh and install oh-my-zsh with some plugins
sh ${scripts_dir}/common/oh-my-zsh.sh


### Ending Messages ###

echo -e "${GREEN}Bravo!!!!!, The system is ready${NC}"

echo "You can start x environment with startx and enjoy."
