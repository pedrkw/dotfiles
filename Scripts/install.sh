#!/bin/bash
  timedatectl set-ntp true
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
#cp /etc/pacman.d/mirrorlist /etc/pacmand./mirrorlist.backup
reflector --verbose --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
echo -e "${RED}Hey, don't forget to format disk on${NC} ${GREEN}DOS${NC} ${RED}and create${NC} ${GREEN}ONLY ONE${NC} ${RED}partition..${NC}"
 read $tmp
  cfdisk -z /dev/sda
echo
  lsblk -f
echo
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
  clear
  lvmdiskscan
  pvcreate /dev/sda1
  pvscan
echo -e "Hey, is that ${RED}right${NC} ?"
echo -e "Press ${GREEN}yes${NC} or ${GREEN}no${NC}"
 read option;
 if [ $option == "yes" ];
 then
  vgcreate weeb /dev/sda1
 elif [ $option == "no" ];
 then
  exit
 fi
  vgs
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
  lvcreate -L 20G weeb -n wroot /dev/sda1
  lvcreate -l 100%FREE weeb -n wswap /dev/sda1
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
  clear
  modprobe dm_mod
  vgscan
  vgchange -ay
  mkfs.ext4 /dev/weeb/wroot
  mkswap /dev/weeb/wswap
echo -e "-"
  lsblk -f
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
  swapon /dev/weeb/wswap
  mount /dev/weeb/wroot /mnt
 sleep 05
  clear
  lsblk -f
echo -e ""
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
echo -e "${RED}Edit${NC} your ${RED}pacman.conf${NC}"
echo -e "Remember: ${GREEN}downlods${NC} and ${GREEN}multilib${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
 vim /etc/pacman.conf
  pacstrap -K /mnt linux linux-firmware base base-devel networkmanager vim grub efibootmgr xorg-server xorg-xinit fish lvm2 firefox gnu-free-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts ttf-liberation ttf-croscore ttf-dejavu ttf-bitstream-vera ttf-droid ttf-croscore xfce4 xfce4-goodies lightdm-gtk-greeter lightdm-gtk-greeter-settings lightdm  ttf-ibm-plex git
  genfstab -U /mnt > /mnt/etc/fstab
  cat /mnt/etc/fstab
echo -e " All right ?"
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
echo -e "Heey, don't forget, ${GREEN}lvm2${NC} module is important"
echo -e "HOOKS=(base udev ... ${RED}block${NC} -->> ${GREEN}lvm2${NC} <<-- ${RED}filesystems)${NC}"
arch-chroot /mnt /bin/bash -c "vim /etc/mkinitcpio.conf"
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
arch-chroot /mnt /bin/bash -c "pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com"
arch-chroot /mnt /bin/bash -c "pacman-key --lsign-key FBA220DFC880C036"
arch-chroot /mnt /bin/bash -c "pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'"
arch-chroot /mnt /bin/bash -c "echo "[chaotic-aur]" >> /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "pacman -Syu paru linux-tkg-cfs-generic_v3 ttf-juliamono spotify anydesk-bin visual-studio-code-bin droidcam mangohud lib32-mangohud heroic-games-launcher-bin wine-tkg-staging-fsync-git vulkan-icd-loader lib32-vulkan-icd-loader"
#arch-chroot /mnt /bin/bash -c "timedatectl set-ntp true"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo LANG=en_US.UTF-8 > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo deltarch >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo KEYMAP=br-abnt2 >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
arch-chroot /mnt /bin/bash -c "systemctl enable lightdm"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -s /bin/fish pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(user account)"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(root account)${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd root"
echo -e "Press ${GREEN}enter${NC} to continue and edit ${RED}sudoers file${NC}"
arch-chroot /mnt /bin/bash -c "visudo /etc/sudoers"
#arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinuxGRUB"
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda"
echo -e "Heey, don't forget, ${RED}lvm${NC} module (/etc/default/grub) is important"
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/default/grub"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
