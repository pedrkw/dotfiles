#!/bin/bash
whoami=$(whoami)


     echo -e "Scrit feito por @pedrkw (Telegram)"
     echo -e "não me responsabilizo por qualquer uso indevido"
     echo -e "deste script, ele foi criado para uso pessoal"
     echo -e "e armazenado publicamente no github. @pedrkw"
     echo -e "SCRIPT FEITO PARA USAR EM MODO BIOS/MBR/LEGACY!!"
     echo -e "QUALQUER DUVIDA EXTRA EU INDICO E RECOMENDO QUE USE O"
     echo -e "SITE OFICIAL archlinux.org"

sleep 10

reset

     echo -e "Configurando teclado"
loadkeys br-abnt2

     echo -e "Teclado configurado"

sleep 02

     echo -e "A seguir vamos definir a linguagem do ambiente live"
     echo -e "descomente a opção que corresponder a sua linguagem"

sleep 05

vim /etc/locale.gen

      echo -e "Gerando o arquivo linguagem"
locale-gen

      echo -e "Arquivo Gerado com sucesso"

sleep 02

      echo -e "Atualizando rélogio do sistema"
timedatectl set-ntp true

sleep 02

       echo -e "Iniciando o particionado"
cfdisk
       echo -e "Formatando partições"
reset
lsblk
       echo -e "Informe as devidas partições"
       echo -e "Exemplo: /dev/sdaX"
       echo -e "Partição ROOT"
       read root

mkfs.ext4 $root

       echo -e "Partição SWAP"
       echo -e "Exemplo: /dev/sdaX"
       read swap

mkswap $swap
swapon $swap

       echo -e "Partição HOME"
       echo -e "Exemplo /dev/sdaX"
       read home

mkfs.ext4 $home

       echo -e "Formatação Concluída"

sleep 05
 
        echo -e "Montando sistema de arquivos"

mount $root /mnt
mkdir /mnt/home
mount $home /mnt/home

        echo -e "Montagem concluída"

sleep 05
        echo -e "Iniciando a instalação dos pacotes essenciais"

pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim bspwm feh dunst git dmenu rofi wget pacman-contrib python2 grub scrot flameshot simplescreenrecoder python-gobject python-dbus python-pywal bash-completion xdg-user-dirs firefox firefox-i18n-br pcmanfm-gtk3 lxappearance-gtk3 xsecurelock xed mpv youtube-dl ffmpeg gvfs gvfs-mtp transmission-gtk libnotify psensor polkit polkit-gnome gparted sakura rxvt-unicode xarchiver xorg-server xorg-xinit xorg-apps alsa-utils pulseaudio pavucontrol alsa-oss alsa-lib gufw noto-fonts ttf-ubuntu-font-family ttf-dejavu gnu-free-fonts ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font ttf-font-awesome

         echo -e "Comando pacstrap executado com sucesso"

sleep 02

         echo -e "Gerando fstab..."

genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

sleep 08

         echo -e "Entrando em chroot"

         echo -e "arch-chroot /mnt"
sleep 02

          
