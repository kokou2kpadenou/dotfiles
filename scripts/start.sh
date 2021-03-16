#!/bin/sh

entry=""

read -p "Dotfiles folder name (default: .dotfiles): " entry

if [ "$entry" = "" ]; then 
  entry=".dotfiles"
fi


# OS Selection
os=""

PS3='Please select the Operation System: '
options=("CentOS" "Archlinux")
select opt in "${options[@]}"
do
  case $opt in
    "CentOS")
      os="centos"
      break
      ;;
    "Archlinux")
      os="archlinux"
      break
      ;;
    *) echo "invalid option $REPLY";;
  esac
done

clear

git clone https://github.com/kokou2kpadenou/dotfiles.git "$entry" && sh ${entry}/scripts/${os}/post_install.sh
