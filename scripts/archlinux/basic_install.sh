#!/bin/bash
# WARNING: this script will destroy data on the selected disk.

# set -uo pipefail
# trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# Color
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color


### Get infomation from user ###
clear
echo "Welcome Archlinux Basic Installation"
echo
# Get hotname
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
while [ "$device" = "" ]; do
  read -p "Select installation disk: " device
done
echo

# Get layout
layout=""

PS3='Please layout: '
options=("BIOS" "UEFI")
select opt in "${options[@]}"
do
  case $opt in
    "BIOS")
      layout=1
      break
      ;;
    "UEFI")
      layout=2
      break
      ;;
    *) echo "invalid option $REPLY";;
  esac
done
echo

# Get processor
processor=""

PS3='Please select processor: '
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
    *) echo "invalid option $REPLY";;
  esac
done
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
    parted --script "${device}" -- mklabel gpt \
      mkpart primary linux-swap 1Mib ${swap_end} \
      mkpart primary ext4 ${swap_end} 100%

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

read

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
  pulseaudio git reflector xdg-utils xdg-user-dirs

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
arch-chroot /mnt systemctl enable cups.service
arch-chroot /mnt useradd -m ${user}
arch-chroot /mnt usermod -aG libvirt ${user}

echo "$user ALL=(ALL) ALL" >> /mnt/etc/sudoers.d/${user}

echo "$user:$password" | chpasswd --root /mnt
echo "root:$root_password" | chpasswd --root /mnt


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

# reboot
