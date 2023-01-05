#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
reflector --verbose --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
echo -e "${RED}Hey, don't forget to create${NC} ${GREEN}UEFI${NC} ${RED}partition${NC}"
 read $tmp
  cfdisk -z /dev/sda
  cfdisk -z /dev/sdb
echo
  lsblk -f
echo
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
  clear
  lvmdiskscan
  pvcreate /dev/sda2
  pvcreate /dev/sdb1
  pvscan
echo -e "Hey, is that ${RED}right${NC} ?"
echo -e "Press ${GREEN}yes${NC} or ${GREEN}no${NC}"
 read option;
 if [ $option == "yes" ];
 then
  vgcreate weeb /dev/sda2 /dev/sdb1
 elif [ $option == "no" ];
 then
  exit
 fi
  vgs
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
  lvcreate -l 100%FREE weeb -n wroot /dev/sda2
  lvcreate -L 16G weeb -n wswap /dev/sdb1
  lvcreate -L 32G weeb -n wvar /dev/sdb1
  lvcreate -L 300G weeb -n whdd /dev/sdb1
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
  clear
  modprobe dm_mod
  vgscan
  vgchange -ay
  mkfs.fat -F32 /dev/sda1
  mkfs.ext4 /dev/weeb/wroot
  mkfs.ext4 /dev/weeb/wvar
  mkfs.ext4 /dev/weeb/whdd
  mkswap /dev/weeb/wswap
echo -e "-"
  lsblk -f
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
mount /dev/weeb/wroot /mnt
mkdir -p /mnt/{var,hdd,boot/efi}
mount /dev/sda1 /mnt/boot/efi
mount /dev/weeb/wvar /mnt/var
mount /dev/weeb/whdd /mnt/hdd
swapon /dev/weeb/wswap
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
  pacstrap -K /mnt linux linux-firmware base base-devel flameshot bash-completion easyeffects pipewire lib32-pipewire pipewire-alsa pipewire-pulse wireplumber maim persepolis aria2 bitwarden vulkan-radeon xf86-video-amdgpu lib32-vulkan-radeon lib32-mesa libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau steam gamemode lib32-gamemode libva-vdpau-driver libvdpau-va-gl vulkan-tools obsidian obs-studio papirus-icon-theme materia-gtk-theme discord mpv giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs lutris networkmanager vim grub xorg-server xorg-xinit fish lvm2 firefox gnu-free-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts ttf-liberation ttf-croscore ttf-dejavu ttf-bitstream-vera ttf-droid ttf-croscore ttf-ibm-plex git xdg-user-dirs openssh ufw gufw gparted pacman-contrib efibootmgr reflector flameshot
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
arch-chroot /mnt /bin/bash -c "pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm"
arch-chroot /mnt /bin/bash -c "echo '[chaotic-aur]' >> /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "vim /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "pacman -Syu paru carla menulibre linux-tkg-cfs-generic_v3 authy ttf-juliamono spotify anydesk-bin visual-studio-code-bin droidcam mangohud lib32-mangohud hunspell hunspell-en_us hunspell-pt-br heroic-games-launcher-bin wine-tkg-staging-fsync-git vulkan-icd-loader lib32-vulkan-icd-loader noto-color-emoji-fontconfig btop --noconfirm"
#arch-chroot /mnt /bin/bash -c "pacman -Syu --noconfirm xorg rofi python-pywal polybar kitty i3-wm dmenu mpv dunst pcmanfm-gtk3 materia-gtk-theme papirus-icon-theme lxappearance-gtk3 viewnior transmission-gtk aria2 curl feh maim smartmontools neofetch yad"
arch-chroot /mnt /bin/bash -c "pacman -Syu latte-dock plasma-meta dolphin vlc elisa materia-kde kvantum-theme-materia konsole sddm kvantum spectacle flatpak okular --noconfirm"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i 's/^#en_US\.UTF-8/en_US\.UTF-8/' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo LANG=en_US.UTF-8 > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo rubedoarch >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo KEYMAP=br-abnt2 >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
arch-chroot /mnt /bin/bash -c "systemctl enable sddm"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -s /bin/fish pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(user account)"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(root account)${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd root"
echo -e "Press ${GREEN}enter${NC} to continue and edit ${RED}sudoers file${NC}"
arch-chroot /mnt /bin/bash -c "visudo /etc/sudoers"
arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinuxGRUB"
echo -e "Heey, don't forget, ${RED}lvm${NC} module (/etc/default/grub) is important"
echo -e "Press ${GREEN}enter${NC} to continue"
 read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/default/grub"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
