#!/bin/bash
# WARNING: this script will destroy data on the selected disk.
# This script can be run by executing the following:
#   curl -sL https://git.io/vNxbN | bash
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# REPO_URL="https://s3.eu-west-2.amazonaws.com/mdaffin-arch/repo/x86_64"

### Get infomation from user ###
hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

user=$(dialog --stdout --inputbox "Enter admin username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
clear

layout=$(dialog --stdout --menu "Select layout" 0 0 0 1 BIOS 2 UEFI) || exit 1
clear

processor=$(dialog --stdout --menu "Select processor ucode" 0 0 0 amd-ucode "amd processor" intel-ucode "intel processor")
clear

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
      mkpart primary linux-swap 1MiB ${swap_end} \
      mkpart primary ext4 ${swap_end} 100%

    # Simple globbing was not enough as on one device I needed to match /dev/mmcblk0p1
    # but not /dev/mmcblk0boot1 while being able to match /dev/sda1 on other devices.
    part_swap="$(ls ${device}* | grep -E "^${device}p?2$")"
    part_root="$(ls ${device}* | grep -E "^${device}p?3$")"

    wipefs "${part_swap}"
    wipefs "${part_root}"

    mkswap "${part_swap}"
    mkfs.ext4 -f "${part_root}"

    swapon "${part_swap}"
    mount "${part_root}" /mnt

    echo "colo toure"
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
    mkfs.ext4 -f "${part_root}"

    swapon "${part_swap}"
    mount "${part_root}" /mnt
    mkdir /mnt/boot
    mount "${part_boot}" /mnt/boot
    ;;
esac


### Install and configure the basic system ###

pacstrap /mnt base linux linux-firmware vim ${processor}

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

arch-chroot /mnt hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

arch-chroot /mnt locale-gen

echo "${hostname}" > /mnt/etc/hostname

cat >> /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${hostname}.localdomain    ${hostname}
EOF

arch-chroot /mnt pacman -S grub networkmanager dialog mtools \
  dosfstools base-devel linux-headers cups alsa-utils \
  pulseaudio git reflector xdg-utils xdg-user-dirs


case $layout in
  1)
    #BIOS
    arch-chroot /mnt grub-install --target=i386-pc ${device}
    ;;
  2)
    #UEFI
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot
    ;;
esac

arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg && \
            systemctl enable NetworkManager && \
            systemctl enable cups.service && \
            useradd -mG wheel ${user}


echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt

umount /mnt/boot && umount /mnt

reboot
