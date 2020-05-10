#!/bin/bash
# find the current user.
whoami=$(whoami)
 
     echo -e "Definindo o fuso horario"
ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime
hwclock --systohc

     echo -e "Definindo o idioma do sistema"

sed -i  '/pt_BR/,+1 s/^#//' /etc/locale.gen

locale-gen

     echo "LANG=pt_BR.UTF-8" > /etc/locale.conf

     echo "archlinux" > /etc/hostname

     echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
     
     echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts

     echo "::1 localhost.localdomain localhost" >> /etc/hosts

     echo "127.0.1.1 archlinux.localdomain" >> /etc/hosts

     echo "nameserver 1.1.1.1" >> /etc/resolv.conf

     echo "nameserver 8.8.8.8" >> /etc/resolv.conf

     echo -e "Concluido"

sleep 05

systemctl enable dhcpcd

useradd -m -g users -G log,sys,wheel,rfkill,dbus -s /bin/bash pedrkw

passwd pedrkw

passwd

vim /etc/sudoers

sleep 05

     echo -e "Instalando BOOTLOADER (GRUB)"
mkinitcpio -P

grub-install /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

sleep 05

      echo -e "Instalação concluida"

sleep 01
