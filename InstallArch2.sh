#!/bin/bash
     echo -e "Definindo o fuso horario"
ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime
hwclock --systohc

     echo -e "Definindo o idioma do sistema"

sed -i  '/pt_BR/,+1 s/^#//' /etc/locale.gen

locale-gen
     echo "Definindo o idioma do sistema"
     echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
     echo "Idioma definido"
clear
     echo "Definindo o nome da maquina/hostname"
     echo "archlinux" > /etc/hostname
     echo "Definido com sucesso"
clear
     echo "Definindo layout do teclado"
     echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
     echo "Layout definido com sucesso"
clear
     echo "Configuranto o arquivo em /etc/hosts"
     echo "127.0.0.1 localhost.localdomain localhost" >> /etc/hosts

     echo "::1 localhost.localdomain localhost" >> /etc/hosts

     echo "127.0.1.1 archlinux.localdomain" >> /etc/hosts
     echo "Configurado com sucesso"
clear
     echo "Definindo os DNS em /etc/resolv.conf"
     echo "nameserver 1.1.1.1" >> /etc/resolv.conf

     echo "nameserver 8.8.8.8" >> /etc/resolv.conf
     echo "Definido com sucesso"
clear
     echo "Habilitando o serviço DHCPCD"
systemctl enable dhcpcd
clear
     echo "Criando usuario"
useradd -m -g users -G log,sys,wheel,rfkill,dbus -s /bin/bash pedrkw
clear
     echo "Digite a senha do usuario"
passwd pedrkw
clear
     echo "Digite a senha do usuario ROOT"
passwd
     echo "Descomentando a linha %wheel ALL=(ALL) em /etc/sudoers"
sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
     echo "Descomentado com sucesso"
clear
     echo "Instalando BOOTLOADER (GRUB)"
mkinitcpio -P

grub-install /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

clear
      echo "Instalação concluida"
