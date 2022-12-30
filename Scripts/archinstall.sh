#!/bin/bash
  timedatectl set-ntp true
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
#cp /etc/pacman.d/mirrorlist /etc/pacmand./mirrorlist.backup
#reflector --verbose --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
echo -e "${RED}Hey, don't forget to create UEFI partition..${NC}"
 read $tmp
  cfdisk -z /dev/sda
echo
echo -e "Hey, you wish go to other disk ?"
 read $tmp
  cfdisk -z /dev/sdb
  clear
echo -e "Hey, is that ${RED}right${NC} ?"
echo
  lsblk -f
echo
 read $tmp
  clear
  lvmdiskscan
  pvcreate /dev/sda2
  pvcreate /dev/sdb1
  pvscan
echo -e "Hey, is that ${RED}right${NC} ?"
echo -e "Yes"
echo -e "No"
 read option;
 if [ $option == "Yes" ];
 then
  vgcreate weeb /dev/sda2 /dev/sdb1
 elif [ $option == "No" ];
 then
  exit
 fi
  vgs
echo -e "Press ENTER"
 read $tmp
  lvcreate -l 100%FREE weeb -n wroot /dev/sda2
  #lvcreate -L 2G weeb -n wtmp /dev/sdb1
  lvcreate -L 16G weeb -n wswap /dev/sdb1
  lvcreate -L 32G weeb -n wvar /dev/sdb1
  lvcreate -L 300G weeb -n whdd /dev/sdb1
echo -e "All are ${RED}okay${NC} ?"
 read $tmp
  clear
  modprobe dm_mod
  vgscan
  vgchange -ay
  mkfs.fat -F32 /dev/sda1
  mkfs.ext4 /dev/weeb/wroot
  #mkfs.ext4 /dev/weeb/wtmp
  mkfs.ext4 /dev/weeb/wvar
  mkfs.ext4 /dev/weeb/whdd
  mkswap /dev/weeb/wswap
echo -e "-"
  lsblk -f
 read $tmp
  swapon /dev/weeb/wswap
  mount /dev/weeb/wroot /mnt
  mkdir /mnt/boot
  mkdir /mnt/boot/efi
  #mkdir /mnt/{var,tmp}
  mkdir /mnt/var
  mkdir /mnt/hdd
  mount /dev/sda1 /mnt/boot/efi
  #mount /dev/weeb/wtmp /mnt/tmp
  mount /dev/weeb/wvar /mnt/var
  mount /dev/weeb/whdd /mnt/hdd
 sleep 05
  clear
echo -e "Is that right?"
  lsblk -f
echo -e ""
 read $tmp
echo -e "Edit your pacman.conf"
 read $tmp
 vim /etc/pacman.conf
  pacstrap -K /mnt linux linux-firmware base base-devel networkmanager vim grub efibootmgr xorg-server xorg-xinit fish lvm2 firefox gnu-free-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts ttf-liberation ttf-croscore ttf-dejavu ttf-bitstream-vera ttf-droid ttf-croscore ttf-ibm-plex git
  genfstab -U /mnt >> /mnt/etc/fstab
  cat /mnt/etc/fstab
echo -e "Hey, honey, is right ?"
 read $tmp
 echo -e "Heey, don't forget, ${RED}lvm2${NC} module is important"
 read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/mkinitcpio.conf"
arch-chroot /mnt /bin/bash -c "timedatectl set-ntp true"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo LANG=en_US.UTF-8 > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo deltarch >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo KEYMAP=br-abnt2 >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
#arch-chroot /mnt /bin/bash -c "systemctl enable sddm"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -s /bin/fish pedrokw"
echo -e "${RED}Hey honey, chose your password (user account)${NC}"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
echo -e "${RED}Hey honey, chose your password (root account)${NC}"
arch-chroot /mnt /bin/bash -c "passwd root"
arch-chroot /mnt /bin/bash -c "visudo /etc/sudoers"
arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinuxGRUB"
echo -e "Heey, don't forget, ${RED}lvm2${NC} module is important"
echo -e "HOOKS=(base udev ... ${RED}block${NC} -->> ${GREEN}lvm2${NC} <<-- ${RED}filesystems)${NC}"
 read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/mkinitcpio.conf"
echo -e "Heey, don't forget, ${RED}lvm${NC} module (/etc/default/grub) is important"
 read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/default/grub"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
