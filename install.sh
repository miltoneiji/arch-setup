#!/bin/bash

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINE0": $BASH_COMMAND"; exit $s' ERR

hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
clear

###############################################################################
## Pre-installation ###########################################################
###############################################################################

# Ensure system clock is accurate
timedatectl set-ntp true

# Partition the disks
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + 551 + 1 ))MiB

parted --script "${device}" -- mklabel gpt \
  mkpart ESP fat32 1Mib 551MiB \
  set 1 boot on \
  mkpart primary linux-swap 551MiB ${swap_end} \
  mkpart primary ext4 ${swap_end} 100%

part_boot="$(ls ${device}* | grep -E "^${device}p?1$")"
part_swap="$(ls ${device}* | grep -E "^${device}p?2$")"
part_root="$(ls ${device}* | grep -E "^${device}p?3$")"

# Wipe filesystem signature from devices
wipefs "${part_boot}"
wipefs "${part_swap}"
wipefs "${part_root}"

# Format
mkfs.fat -F32 "${part_boot}"
mkfs.ext4 "${part_root}"
mkswap "${part_swap}"

# Mount the file system
mount "${part_root}" /mnt
swapon "${part_swap}"

###############################################################################
## Installation ###############################################################
###############################################################################

pacstrap /mnt base linux linux-firmware gvim man-db man-pages networkmanager pipewire pipewire-pulse firefox

###############################################################################
## Configure the system #######################################################
###############################################################################

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Time zone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt hwclock --systohc

# Localization
sed -i "/#en_US.UTF-8/s/^#//g" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# Network configuration
echo "${hostname}" > /mnt/etc/hostname
echo -e "127.0.0.1\tlocalhost" >> /mnt/etc/hosts
echo -e "::1\t\tlocalhost" >> /mnt/etc/hosts
echo -e "127.0.0.1\t${hostname}.localdomain ${hostname}" >> /mnt/etc/hosts

# Set the root password
echo -e "Set the root password\n"
arch-chroot /mnt passwd

###############################################################################
## Boot loader ################################################################
###############################################################################

# Microcode
arch-chroot /mnt pacman --noconfirm -S intel-ucode

# GRUB
arch-chroot /mnt pacman --noconfirm -S grub efibootmgr
arch-chroot /mnt mkdir efi
arch-chroot /mnt mount $part_boot /efi
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

###############################################################################
## Extra ######################################################################
###############################################################################

# NetworkManager
arch-chroot /mnt systemclt enable NetworkManager.service

###############################################################################
## Umount #####################################################################
###############################################################################

umount -R /mnt
echo -e "\nYou can reboot your machine and remove the installation media\n"
