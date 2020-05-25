#!/bin/bash
clear

RED='\033[1;31m'
NC='\033[0m'
     echo -e "     ${RED}by @pedrkw ( Telegram )                     ${NC}"
     echo -e "     ${RED}Em caso de dúvidas acesse archlinux.org     ${NC}"
     echo -e "     ${RED}Iniciando script...                         ${NC}"
sleep 10
     echo -e "     ${RED}Iniciando configuração, aguarde...${NC}     "
loadkeys br-abnt2
sed -i  '/pt_BR/,+1 s/^#//' /etc/locale.gen
locale-gen
timedatectl set-ntp true
clear
       echo -e "     ${RED}Parte inicial executada com sucesso${NC}     "
       echo -e "     ${RED}Dando inicio no particionador e continuando o script...${NC}     "
       echo -e "     Pressione a tecla ${RED}ENTER${NC} para continuar...                           "
cfdisk
lsblk
       echo "Informe as devidas partições"
       echo "Exemplo: /dev/sdaX"
       echo "Partição ROOT"
       read root

mkfs.ext4 $root

       echo "========================================="
       echo "Partição SWAP"
       echo "Exemplo: /dev/sdaX"
       read swap

mkswap $swap
swapon $swap

       echo "========================================="
       echo "Partição HOME"
       echo "Exemplo /dev/sdaX"
       read home

mkfs.ext4 $home

       echo "Formatação Concluída"
       echo "Montando sistema de arquivos"
mount $root /mnt
mkdir /mnt/home
mount $home /mnt/home
        echo "Montagem concluída"
sleep 05
clear
        echo -e "     ${RED}Iniciando a instalação dos pacotes essenciais${NC}     "
pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim grub neofetch bash-completion xdg-user-dirs noto-fonts ttf-ubuntu-font-family ttf-dejavu gnu-free-fonts ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font ttf-font-awesome reflector git 

         echo -e "     ${RED}Comando pacstrap executado com sucesso${NC}           "
         echo "Gerando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
         echo "Fstab gerado com sucesso"
cat /mnt/etc/fstab
sleep 05
clear
         echo -e "     ${RED}Entrando em arch-chroot${NC}     "
         echo -e "     ${RED}Pode demorar um pouco, então agurade...${NC}     "
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i  '/pt_BR/,+1 s/^#//' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo 'LANG=pt_BR.UTF-8' > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo 'archlinux' >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo 'KEYMAP=br-abnt2' > /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 localhost.localdomain localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '::1 localhost.localdomain localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '127.0.1.1 archlinux.localdomain' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo 'nameserver 1.1.1.1' >> /etc/resolv.conf"
arch-chroot /mnt /bin/bash -c "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable dhcpcd"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G log,sys,wheel,rfkill,dbus -s /bin/bash pedrkw"
echo -e "     Digite a senha do seu ${RED}USUARIO${NC} a seguir      "
echo -e "     Pressione a tecla ${RED}ENTER${NC} para prosseguir     "
read $tmp
arch-chroot /mnt /bin/bash -c "passwd pedrkw"
echo -e "     Digite a senha do usuario ${RED}ROOT${NC} a seguir     "
echo -e "     Pressione a tecla ${RED}ENTER${NC} para prosseguir     "
read $tmp
arch-chroot /mnt /bin/bash -c "passwd root"
arch-chroot /mnt /bin/bash -c "sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers"
arch-chroot /mnt /bin/bash -c "mkinitcpio -P"
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
echo -e "      ${RED}A instalação foi finalizada${NC}      "
echo -e "      ${RED}Encerrando script, lembre-se de sair do arch-chroot e desmonstar as partições (exit e umount -R /mnt)${NC}      "
