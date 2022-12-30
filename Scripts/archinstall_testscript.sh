#!/bin/bash
  timedatectl set-ntp true
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
#cp /etc/pacman.d/mirrorlist /etc/pacmand./mirrorlist.backup
reflector --verbose --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
echo -e "${RED}Hey, don't forget to create UEFI partition..${NC}"
 read $tmp
  cfdisk -z /dev/sda
echo
echo -e "Hey, is that ${GREEN}right${NC} ?"
echo
  lsblk -f
echo
 read $tmp
  clear
  lvmdiskscan
  pvcreate /dev/sda1
  pvscan
echo -e "Hey, is that ${RED}right${NC} ?"
echo -e "Yes"
echo -e "No"
 read option;
 if [ $option == "Yes" ];
 then
  vgcreate weeb /dev/sda1
 elif [ $option == "No" ];
 then
  exit
 fi
  vgs
echo -e "Press ENTER"
 read $tmp
  lvcreate -L 30G weeb -n wroot /dev/sda1
  lvcreate -L 2G weeb -n wswap /dev/sda1
echo -e "All are ${RED}okay${NC} ?"
 read $tmp
  clear
  modprobe dm_mod
  vgscan
  vgchange -ay
  mkfs.ext4 /dev/weeb/wroot
  mkswap /dev/weeb/wswap
echo -e "-"
  lsblk -f
 read $tmp
  swapon /dev/weeb/wswap
  mount /dev/weeb/wroot /mnt
 sleep 05
  clear
echo -e "Is that right?"
  lsblk -f
echo -e ""
 read $tmp
echo -e "Edit your pacman.conf"
echo -e "Remember: downlods and multilib"
 read $tmp
 vim /etc/pacman.conf
  pacstrap -K /mnt linux linux-firmware base base-devel pipewire lib32-pipewire pipewire-alsa pipewire-pulse wireplumber maim persepolis aria2 bitwarden vulkan-radeon xf86-video-amdgpu lib32-vulkan-radeon lib32-mesa libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau steam gamemode lib32-gamemode libva-vdpau-driver libvdpau-va-gl vulkan-tools obsidian obs-studio papirus-icon-theme materia-gtk-theme discord mpv giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs lutris networkmanager vim grub xorg-server xorg-xinit fish lvm2 firefox gnu-free-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts ttf-liberation ttf-croscore ttf-dejavu ttf-bitstream-vera ttf-droid ttf-croscore ttf-ibm-plex git
  genfstab -U /mnt >> /mnt/etc/fstab
  cat /mnt/etc/fstab
echo -e " All right ?"
 read $tmp
echo -e "Heey, don't forget, ${GREEN}lvm2${NC} module is important"
echo -e "HOOKS=(base udev ... ${RED}block${NC} -->> ${GREEN}lvm2${NC} <<-- ${RED}filesystems)${NC}"
arch-chroot /mnt /bin/bash -c "vim /etc/mkinitcpio.conf"
 read $tmp
arch-chroot /mnt /bin/bash -c "pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com"
arch-chroot /mnt /bin/bash -c "pacman-key --lsign-key FBA220DFC880C036"
arch-chroot /mnt /bin/bash -c "pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'"
arch-chroot /mnt /bin/bash -c "echo "[chaotic-aur]" >> /etc/pacman.conf && echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf"
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
#arch-chroot /mnt /bin/bash -c "systemctl enable sddm"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -s /bin/fish pedrokw"
echo -e "${RED}Hey honey, chose your password (user account)${NC}"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
echo -e "${RED}Hey honey, chose your password (root account)${NC}"
arch-chroot /mnt /bin/bash -c "passwd root"
arch-chroot /mnt /bin/bash -c "visudo /etc/sudoers"
#arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinuxGRUB"
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda"
echo -e "Heey, don't forget, ${RED}lvm${NC} module (/etc/default/grub) is important"
 read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/default/grub"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
