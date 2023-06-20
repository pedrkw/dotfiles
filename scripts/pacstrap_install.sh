#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
#reflector --verbose --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
echo -e "${RED}Edit${NC} your ${RED}pacman.conf${NC}"
echo -e "Remember: ${GREEN}downlods${NC} and ${GREEN}multilib${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
read $tmp
vim /etc/pacman.conf
pacstrap -K /mnt linux linux-headers linux-firmware base base-devel flameshot vivaldi vivaldi-ffmpeg-codecs bash-completion easyeffects pipewire lib32-pipewire pipewire-alsa pipewire-pulse wireplumber maim persepolis aria2 bitwarden vulkan-radeon xf86-video-amdgpu lib32-vulkan-radeon lib32-mesa libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau steam gamemode lib32-gamemode libva-vdpau-driver libvdpau-va-gl vulkan-tools notion obs-studio papirus-icon-theme materia-gtk-theme discord mpv giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins alsa-firmware lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs lutris networkmanager vim grub xorg-server xorg-xinit fish lvm2 firefox gnu-free-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts ttf-liberation ttf-croscore ttf-dejavu ttf-bitstream-vera ttf-droid ttf-croscore ttf-ibm-plex git xdg-user-dirs openssh ufw gufw gparted pacman-contrib efibootmgr reflector terminus-font
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab
echo -e " All right ?"
echo -e "Press ${GREEN}enter${NC} to continue"
read $tmp
echo -e "Heey, don't forget, ${GREEN}lvm2${NC} module is important"
echo -e "HOOKS=(base udev ... ${RED}block${NC} -->> ${GREEN}lvm2${NC} <<-- ${RED}filesystems)${NC}"
read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/mkinitcpio.conf"
echo -e "Press ${GREEN}enter${NC} to continue"
read $tmp
arch-chroot /mnt /bin/bash -c "pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com"
arch-chroot /mnt /bin/bash -c "pacman-key --lsign-key FBA220DFC880C036"
arch-chroot /mnt /bin/bash -c "pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm"
arch-chroot /mnt /bin/bash -c "echo '[chaotic-aur]' >> /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "vim /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "pacman -Syu paru --noconfirm"
#arch-chroot /mnt /bin/bash -c "pacman -Syu --noconfirm xorg rofi python-pywal polybar kitty i3-wm dmenu mpv dunst pcmanfm-gtk3 materia-gtk-theme papirus-icon-theme lxappearance-gtk3 viewnior transmission-gtk aria2 curl feh maim smartmontools neofetch yad"
arch-chroot /mnt /bin/bash -c "pacman -Syu latte-dock plasma-meta dolphin vlc elisa materia-kde kvantum-theme-materia konsole sddm kvantum spectacle okular firewalld kate kdialog dolphin-plugins ffmpegthumbs gwenview kdegraphics-thumbnailers yakuake ark capitaine-cursors sweeper kget ksystemlog kmag kdeconnect juk libktorrent qt5-imageformats kimageformats kwalletmanager telepathy-kde-auth-handler telepathy-kde-auth-handler qtcurve-gtk2 qtcurve-utils telepathy-kde-meta --noconfirm"
arch-chroot /mnt /bin/bash -c "pacman -Syu sddm --noconfirm"
#arch-chroot /mnt /bin/bash -c "pacman -Syu gnome-shell gnome-control-center gnome-text-editor yaru-gnome-shell-theme gdm mpv totem nautilus p7zip unrar evince eog sushi gnome-calculator gnome-calendar gnome-clocks lollypop gnome-system-monitor gnome-tweaks tilix file-roller transmission-gtk xdg-desktop-portal-gnome xdg-user-dirs-gtk gnome-browser-connector"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i 's/^#en_US\.UTF-8/en_US\.UTF-8/' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo LANG=en_US.UTF-8 > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo rubedoarch >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo KEYMAP=br-abnt2 >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
arch-chroot /mnt /bin/bash -c "systemctl enable sddm"
#arch-chroot /mnt /bin/bash -c "systemctl enable gdm"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -s /bin/fish pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(user account)${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(root account)${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd root"
echo -e "Press ${GREEN}enter${NC} to continue and edit ${RED}sudoers file${NC}"
arch-chroot /mnt /bin/bash -c "visudo /etc/sudoers"
arch-chroot /mnt /bin/bash -c "sudo -u pedrokw paru -Syu carla menulibre linux-tkg-cfs-generic_v3 linux-tkg-cfs-generic_v3-headers authy ttf-juliamono spotify anydesk-bin visual-studio-code-bin droidcam mangohud lib32-mangohud hunspell hunspell-en_us gvfs gvfs-mtp xdg-desktop-portal libxcrypt-compat net-tools inetutils aria2 hunspell-pt-br heroic-games-launcher-bin wine-tkg-staging-fsync-git vulkan-icd-loader lib32-vulkan-icd-loader noto-color-emoji-fontconfig btop ocs-url adw-gtk3-git pop-icon-theme yaru-gtk-theme yaru-icon-theme yaru-sound-theme flatpak flatpak-xdg-utils libportal-qt5 libportal-gtk3 libportal-gtk4 ccache wget ttf-ubuntu-font-family ttf-opensans 64gram-desktop-bin goverlay-git wine-gecko wine-mono wine-nine proton-ge-custom-bin winetricks zenity neofetch jdk-temurin intellij-idea-community-edition pycharm-community-edition icu69-bin gst-plugin-pipewire gst-plugins-ugly gstreamer-vaapi xonotic gnome-sound-recorder ulauncher gnome-boxes docker notification-daemon bat thunderbird thunderbird-i18n-en-us thunderbird-i18n-pt-br seahorse schedtool polkit-gnome lib32-polkit protontricks-git inxi ufetch-git whatsie-git corectrl update-grub bauh clonezilla viper-bin unrar p7zip lib32-libappindicator-gtk2 lib32-libappindicator-gtk3 libappindicator-gtk2 libappindicator-gtk3 xsettingsd print-manager cups system-config-printer cups-pdf mysql keepassxc ttf-monoid ttf-fira-code ttf-terminus-nerd ttf-iosevka gnome-calculator gnome-clocks gnome-sound-recorder webapp-manager rustdesk-bin imagemagick inkscape optipng apache phpmyadmin google-chrome gst-plugins-bad ipp-usb ipp-usb gst-libav gst-plugins-good gst-plugins-ugly sdl_image hplip libusb python-pyqt5 python-reportlab python-pillow xsane sane usbutils youtube-music-bin peek pipewire-jack alsa-oss lib32-alsa-oss alsa-utils replay-sorcery cmake extra-cmake-modules checkupdates-aur virtualbox virtualbox-host-dkms virtualbox-guest-iso gimp gimp-extras ttf-jetbrains-mono --noconfirm"
arch-chroot /mnt /bin/bash -c "sudo -u pedrokw paru -Syu plasma-meta dolphin vlc elisa materia-kde kvantum-theme-materia konsole sddm kvantum spectacle okular firewalld kate kdialog dolphin-plugins ffmpegthumbs gwenview kdegraphics-thumbnailers yakuake ark capitaine-cursors sweeper kget ksystemlog kmag kdeconnect juk libktorrent qt5-imageformats kimageformats kwalletmanager telepathy-kde-auth-handler telepathy-kde-auth-handler qtcurve-gtk2 qtcurve-utils telepathy-kde-meta --noconfirm"
arch-chroot /mnt /bin/bash -c "usermod -aG games,gamemode pedrokw"
#arch-chroot /mnt /bin/bash -c "echo 'export PATH="$HOME/.local/bin:$PATH"' > /home/pedrokw/.profile"
#arch-chroot /mnt /bin/bash -c "cat /home/pedrokw/.profile"
#arch-chroot /mnt /bin/bash -c "${GREEN}All right{NC}"
read $tmp
arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinuxGRUB"
echo -e "Heey, don't forget, ${RED}lvm${NC} module (/etc/default/grub) is important"
echo -e "Press ${GREEN}enter${NC} to continue"
read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/default/grub"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
