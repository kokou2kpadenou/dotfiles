#!/bin/bash
# WARNING: this script will destroy data on the selected disk.
# COMMAND: bash <(curl -sL https://git.io/Jm3xB)

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# Color
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHTGRAY='\033[0;37m'
NC='\033[0m'  # No Color


### Get infomation from user ###
clear
echo "Welcome Archlinux Basic Installation"
echo
# Get hostname
hostname=""
while [ "$hostname" = "" ]; do
  read -p "Enter hostname: " hostname
done
echo

# Get user
user=""
while [ "$user" = "" ]; do
  read -p "Enter admin username: " user
done
echo

# Get admin password
password=""
password2="2"
while [[ "$password" = "" || "$password" != "$password2" ]]; do
  read -s -p "Enter admin password: " password
  echo
  read -s -p "Enter admin password again: " password2
  echo
  [[ "$password" = "" ]] && echo -e "${RED}Admin password cannot be empty${NC}" || \
  [[ "$password" == "$password2" ]] || echo -e "${RED}Passwords did not match${NC}"
done
echo

# Get root password
root_password=""
root_password2="2"
while [[ "$root_password" = "" || "$root_password" != "$root_password2" ]]; do
  read -s -p "Enter root password: " root_password
  echo
  read -s -p "Enter root password again: " root_password2
  echo
  [[ "$root_password" = "" ]] && echo -e "${RED}Root password cannot be empty${NC}" || \
  [[ "$root_password" == "$root_password2" ]] || echo -e "${RED}Passwords did not match${NC}"
done
echo

# Get device
device=""
echo Physic Disks Disponible:
lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac
echo
while [[ "$device" = "" || $(lsblk -dpln -o name | grep ${device}) = "" ]]; do
  read -p "Select installation disk (ex. /dev/sdX): " device
  [[ $(lsblk -dpln -o name | grep ${device}) ]] || echo -e "${RED}invalid disk, please choose from the list${NC}"
done
echo

# Get layout
layout=""

PS3='Please select layout: '
options=("BIOS/MBR" "UEFI/GPT")
select opt in "${options[@]}"
do
  case $opt in
    "BIOS/MBR")
      layout=1
      break
      ;;
    "UEFI/GPT")
      layout=2
      break
      ;;
    *) echo -e "${RED}invalid option $REPLY${NC}";;
  esac
done
echo

# Get processor
processor=""

PS3='Please select processor type: '
options=("amd" "intel")
select opt in "${options[@]}"
do
  case $opt in
    "amd")
      processor="amd-ucode"
      break
      ;;
    "intel")
      processor="intel-ucode"
      break
      ;;
    *) echo -e "${RED}invalid option $REPLY${NC}";;
  esac
done
echo

clear
echo Inputs Summary
echo --------------
echo -e "Hostname: ${LIGHTGRAY}$hostname${NC}"
echo -e "Admin user: ${LIGHTGRAY}$user${NC}"
echo -e "Admin user password: ${LIGHTGRAY}set${NC}"
echo -e "Root password ${LIGHTGRAY}set${NC}"
echo -e "Select Device: ${LIGHTGRAY}$device${NC}"
echo -e "Selected Layout: ${LIGHTGRAY}$layout${NC}"
echo -e "Selected processor: ${LIGHTGRAY}$processor${NC}"
echo
echo -e "I ${RED}love ${GREEN}LINUX${NC}"
echo -e "${RED}WARNING: this script will destroy data on the selected disk $device.${NC}"
echo -e "Hit ${GREEN}enter${NC} to start the installation or ${RED}^c${NC} to abort."
read

### Set up logging ###
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

timedatectl set-ntp true

### Setup the disk and partitions ###
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')*2
swap_end=$(( $swap_size + 260 + 1 ))MiB

case $layout in
  1)
    # BIOS
    parted --script "${device}" -- mklabel msdos \
      mkpart primary linux-swap 1Mib ${swap_end} \
      mkpart primary ext4 ${swap_end} 100% \
      set 1 boot on

    # Simple globbing was not enough as on one device I needed to match /dev/mmcblk0p1
    # but not /dev/mmcblk0boot1 while being able to match /dev/sda1 on other devices.
    part_swap="$(ls ${device}* | grep -E "^${device}p?1$")"
    part_root="$(ls ${device}* | grep -E "^${device}p?2$")"

    wipefs "${part_swap}"
    wipefs "${part_root}"

    mkswap "${part_swap}"
    mkfs.ext4 "${part_root}"

    swapon "${part_swap}"
    mount "${part_root}" /mnt

    ;;

  2)
    # UEFI
    parted --script "${device}" -- mklabel gpt \
      mkpart ESP fat32 1Mib 260MiB \
      set 1 boot on \
      mkpart primary linux-swap 260MiB ${swap_end} \
      mkpart primary ext4 ${swap_end} 100%

    # Simple globbing was not enough as on one device I needed to match /dev/mmcblk0p1
    # but not /dev/mmcblk0boot1 while being able to match /dev/sda1 on other devices.
    part_boot="$(ls ${device}* | grep -E "^${device}p?1$")"
    part_swap="$(ls ${device}* | grep -E "^${device}p?2$")"
    part_root="$(ls ${device}* | grep -E "^${device}p?3$")"

    wipefs "${part_boot}"
    wipefs "${part_swap}"
    wipefs "${part_root}"

    mkfs.fat -F32 "${part_boot}"
    mkswap "${part_swap}"
    mkfs.ext4 "${part_root}"

    swapon "${part_swap}"
    mount "${part_root}" /mnt
    mkdir /mnt/boot/efi
    mount "${part_boot}" /mnt/boot/efi
    ;;
esac


### Install and configure the basic system ###

pacstrap /mnt base linux linux-firmware vim ${processor}

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

arch-chroot /mnt hwclock --systohc

sed -i '/^#en_US.UTF-8 UTF-8/s/^#//g' /mnt/etc/locale.gen

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

arch-chroot /mnt locale-gen

echo "${hostname}" > /mnt/etc/hostname

cat >> /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${hostname}.localdomain    ${hostname}
EOF

arch-chroot /mnt pacman -S --noconfirm grub networkmanager dialog mtools \
  dosfstools base-devel linux-headers cups alsa-utils \
  pulseaudio git reflector rsync xdg-utils xdg-user-dirs ipset ebtables firewalld
  
# arch-chroot /mnt sudo reflector -c "United States" -a 6 --sort rate --save /etc/pacman.d/mirrorlist

# arch-chroot /mnt sudo pacman -Syyuu

case $layout in
  1)
    #BIOS
    arch-chroot /mnt grub-install --target=i386-pc ${device}
    ;;
  2)
    #UEFI
    arch-chroot /mnt pacman -S --noconfirm efibootmgr
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
    ;;
esac

arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable cups
arch-chroot /mnt systemctl enable firewalld
arch-chroot /mnt useradd -m ${user}

echo "$user ALL=(ALL) ALL" >> /mnt/etc/sudoers.d/${user}

echo "$user:$password" | chpasswd --root /mnt
echo "root:$root_password" | chpasswd --root /mnt


# umount ${device}*
case $layout in
  1)
    #BIOS
    umount /mnt
    ;;
  2)
    #UEFI
    umount /mnt/boot/efi && umount /mnt
    ;;
esac


echo -e "${GREEN}Done! Hit Enter to reboot the machine.${NC}"

read

reboot
