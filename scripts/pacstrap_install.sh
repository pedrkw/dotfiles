#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
# reflector --verbose --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
echo -e "${RED}Edit${NC} your ${RED}pacman.conf${NC}"
echo -e "Remember: ${GREEN}downlods${NC} and ${GREEN}multilib${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
read $tmp
vim /etc/pacman.conf
pacstrap -K /mnt linux linux-headers linux-firmware base base-devel bash-completion pipewire lib32-pipewire pipewire-alsa pipewire-pulse wireplumber aria2 bitwarden vulkan-radeon xf86-video-amdgpu lib32-vulkan-radeon lib32-mesa mesa-vdpau lib32-mesa-vdpau steam gamemode lib32-gamemode vulkan-tools obs-studio papirus-icon-theme materia-gtk-theme discord giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins alsa-firmware lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs lutris networkmanager vim grub xorg-server xorg-xinit lvm2 firefox gnu-free-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts ttf-dejavu ttf-liberation git xdg-user-dirs openssh pacman-contrib efibootmgr reflector qbittorrent vivaldi vivaldi-ffmpeg-codecs
# removed pkgs: zsh-autosuggestions zsh-completions ttf-droid ttf-bitstream-vera ttf-ibm-plex terminus-font ttf-croscore fish zsh maim flameshot sof-firmware
# video driver:  libva-vdpau-driver lib32-libva-mesa-driver libvdpau-va-gl lib32-libvdpau
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
echo -e "Installing ${GREEN}Chaotic AUR${NC}..."
arch-chroot /mnt /bin/bash -c "pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com"
arch-chroot /mnt /bin/bash -c "pacman-key --lsign-key 3056513887B78AEB"
arch-chroot /mnt /bin/bash -c "pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'"
arch-chroot /mnt /bin/bash -c "echo '[chaotic-aur]' >> /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf"
# echo -e "Chaotic AUR installed!"
# echo -e "Edit pacman.conf"
arch-chroot /mnt /bin/bash -c "vim /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "pacman -Syu paru --noconfirm"
# arch-chroot /mnt /bin/bash -c "pacman -Syu --noconfirm xorg rofi polkit-gnome python-pywal polybar kitty i3-wm dmenu mpv dunst pcmanfm-gtk3 materia-gtk-theme papirus-icon-theme lxappearance-gtk3 viewnior transmission-gtk aria2 curl feh maim smartmontools neofetch yad"
arch-chroot /mnt /bin/bash -c "pacman -Syu plasma-meta dolphin vlc konsole sddm spectacle okular kate kdialog dolphin-plugins ffmpegthumbs gwenview kdegraphics-thumbnailers yakuake ark sweeper ksystemlog kmag kdeconnect libktorrent qt5-imageformats kimageformats kwalletmanager xdg-desktop-portal-kde plasma-wayland-protocols kalk kclock krecorder --noconfirm"
# elisa qtcurve-gtk2 qtcurve-utils plasma-wayland-session materia-kde kvantum-theme-materia kvantum ufw
# arch-chroot /mnt /bin/bash -c "pacman -Syu adw-gtk3-git gnome-shell gnome-control-center gnome-text-editor yaru-gnome-shell-theme gdm mpv totem nautilus p7zip unrar evince eog sushi gnome-calculator gnome-calendar gnome-clocks lollypop gnome-system-monitor gnome-tweaks tilix file-roller xdg-desktop-portal-gnome xdg-user-dirs-gtk gnome-browser-connector polkit-gnome seahorse python-nautilus adwaita-qt5 adwaita-qt6 qt5-styleplugins nautilus-image-converter ufw gufw gparted"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i 's/^#en_CA\.UTF-8/en_CA\.UTF-8/' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo LANG=en_CA.UTF-8 > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo rubedoarch >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo KEYMAP=br-abnt2 >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
arch-chroot /mnt /bin/bash -c "systemctl enable sddm"
# arch-chroot /mnt /bin/bash -c "systemctl enable gdm"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -s /bin/bash pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(user account)${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
echo -e "${RED}Chose your password${NC} ${GREEN}(root account)${NC}"
echo -e "Press ${GREEN}enter${NC} to continue"
arch-chroot /mnt /bin/bash -c "passwd root"
echo -e "Press ${GREEN}enter${NC} to continue and edit ${RED}sudoers file${NC}"
arch-chroot /mnt /bin/bash -c "visudo /etc/sudoers"
arch-chroot /mnt /bin/bash -c "sudo -u pedrokw paru -Syu lib32-libgudev lib32-libjpeg6-turbo lib32-libtheora lib32-libusb lib32-openssl lib32-speex lib32-vkd3d libjpeg6-turbo openssl menulibre ttf-juliamono anydesk-bin visual-studio-code-bin droidcam mangohud lib32-mangohud hunspell hunspell-en_us gvfs gvfs-mtp xdg-desktop-portal libxcrypt-compat net-tools inetutils aria2 hunspell-pt-br heroic-games-launcher-bin wine-tkg-staging-fsync-git vulkan-icd-loader lib32-vulkan-icd-loader noto-color-emoji-fontconfig btop ocs-url flatpak flatpak-xdg-utils libportal-qt5 libportal-gtk3 libportal-gtk4 ccache wget ttf-ubuntu-font-family ttf-opensans 64gram-desktop-bin goverlay-git wine-gecko wine-mono wine-nine winetricks zenity icu69-bin gst-plugin-pipewire gst-plugins-ugly gstreamer-vaapi docker notification-daemon bat schedtool lib32-polkit protontricks-git inxi ufetch-git corectrl update-grub unrar p7zip lib32-libappindicator-gtk2 lib32-libappindicator-gtk3 libappindicator-gtk2 libappindicator-gtk3 xsettingsd keepassxc  ttf-fira-code ttf-iosevka imagemagick gst-plugins-bad gst-libav gst-plugins-good gst-plugins-ugly sdl_image libusb python-pyqt5 python-reportlab python-pillow usbutils peek pipewire-jack alsa-oss lib32-alsa-oss alsa-utils cmake checkupdates-aur virtualbox virtualbox-host-dkms virtualbox-guest-iso ttf-jetbrains-mono protonup-qt vkd3d htop gtk-engine-murrine fastfetch xclip python-pip rsync os-prober glew1.10 lib32-dbus-glib lib32-freeglut lib32-glew1.10 lib32-imlib2 lib32-libcaca lib32-libcurl-compat lib32-libcurl-gnutls lib32-libgcrypt15 lib32-libidn11 lib32-libmikmod lib32-libmodplug lib32-libnm lib32-libpng12 lib32-librtmp0 lib32-libtiff4 lib32-libudev0-shim lib32-libvpx1.3 lib32-libwebp lib32-libxmu lib32-libxt lib32-openssl lib32-sdl12-compat lib32-sdl2 lib32-sdl2_image lib32-sdl2_mixer lib32-sdl2_ttf lib32-sdl_image lib32-sdl_mixer lib32-sdl_ttf libcurl-compat libgcrypt15 libidn11 libmikmod libpng12 librtmp0 libtiff4 libudev0-shim libvpx openssl sdl2_mixer sdl2_ttf sdl_mixer sdl_ttf flac1.3 lib32-flac1.3 gtk-engines gnu-netcat sdl12-compat lib32-pipewire-jack"
# printer pkgs: cups-pdf hplip print-manager cups system-config-printer xsane sane ipp-usb
# timeshift-autosnap qemu-desktop virt-viewer virt-manager tesseract-data-por tesseract-data-eng python-spotdl apache phpmyadmin proton-ge-custom-bin clonezilla ulauncher thunderbird thunderbird-i18n-en-us thunderbird-i18n-pt-br extra-cmake-modules replay-sorcery mpv whatsie-git ttf-ms-fonts xonotic neofetch google-chrome optipng ttf-mononoki-nerd ttf-monofur-nerd masterpdfeditor-free youtube-music-bin gnome-boxes intellij-idea-community-edition pycharm-community-edition gimp gimp-extras ttf-terminus-nerd ttf-monoid carla linux-tkg-cfs-generic_v3 linux-tkg-cfs-generic_v3-headers authy pop-icon-theme
# gnome-calculator gnome-clocks gnome-sound-recorder
# kalk kclock krecorder 
arch-chroot /mnt /bin/bash -c "sudo -u pedrokw paru -Syu timeshift intel-ucode spotify-launcher powerline-fonts python-pipx docker-compose nodejs npm nvme-cli ttf-roboto ttf-roboto-mono bridge-utils webapp-manager dnsmasq edk2-ovmf libvirt netcat radvd libmms python-protobuf innoextract xorg-xgamma lib32-libpulse lib32-gst-plugins-base gst-plugin-va lib32-gst-plugins-good i2c-tools ddcutil"
# jdk17-openjdk
arch-chroot /mnt /bin/bash -c "echo i2c-dev > /etc/modules-load.d/i2c-dev.conf"
arch-chroot /mnt /bin/bash -c "usermod -aG games,gamemode,i2c pedrokw"
# arch-chroot /mnt /bin/bash -c "sudo -u pedrokw sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)""
read $tmp
arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinuxGRUB"
echo -e "Heey, don't forget, ${RED}lvm${NC} module (/etc/default/grub) is important"
echo -e "Press ${GREEN}enter${NC} to continue"
read $tmp
arch-chroot /mnt /bin/bash -c "vim /etc/default/grub"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
