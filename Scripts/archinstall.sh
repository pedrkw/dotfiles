#!/bin/bash
clear
RED='\033[1;31m'
NC='\033[0m'
sed -i  '/pt_BR.UTF-8/ s/^#//' /etc/locale.gen
locale-gen
export LANG=pt_BR.UTF-8
timedatectl set-ntp true
clear
echo -e "Sincronizando espelhos usando o reflector, aguarde..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
 mkfs.ext4 /dev/sda1
 mkfs.ext4 /dev/sda2
 mount /dev/sda1 /mnt
 mkdir /mnt/home
 mount /dev/sda2 /mnt/home
 pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim grub xorg-server xorg-apps
 genfstab -U /mnt >> /mnt/etc/fstab
 arch-chroot /mnt /bin/bash -c "dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress"
 arch-chroot /mnt /bin/bash -c "chmod 600 /swapfile"
 arch-chroot /mnt /bin/bash -c "mkswap /swapfile"
 arch-chroot /mnt /bin/bash -c "swapon /swapfile"
 arch-chroot /mnt /bin/bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
read $tmp
clear
echo -e "${RED}Entrando em arch-chroot${NC}
Escolha a região mais adequada para definir o fuso horário
Tenha cuidado com maiúsculas e minúsculas"
ls /usr/share/zoneinfo/America/
read zone
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/$zone /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i '/en_US.UTF-8/ s/^#//' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo 'LANG=en_US.UTF-8' > /etc/locale.conf"
echo -e "Digite a seguir o ${RED}HOSTNAME${NC} (nome da maquina)"
read host
arch-chroot /mnt /bin/bash -c "echo '$host' >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo 'KEYMAP=br-abnt2' > /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 localhost.localdomain localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '::1 localhost.localdomain localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '127.0.1.1 archlinux.localdomain' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo 'nameserver 1.1.1.1' >> /etc/resolv.conf"
arch-chroot /mnt /bin/bash -c "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable dhcpcd"
clear
echo -e "Digite o ${RED}nome do seu usuário${NC}"
read user
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel -s /bin/bash $user"
echo -e "Digite a senha do ${RED}SEU USUÁRIO${NC} a seguir
Para prosseguir e digitar a senha, pressione a tecla ${RED}ENTER${NC}"
read $tmp
arch-chroot /mnt /bin/bash -c "passwd $user"
echo -e "Digite a senha do ${RED}USUÁRIO ROOT${NC} a seguir
Para prosseguir e digitar a senha, pressione a tecla ${RED}ENTER${NC}"
read $tmp
arch-chroot /mnt /bin/bash -c "passwd root"
arch-chroot /mnt /bin/bash -c "sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers"
arch-chroot /mnt /bin/bash -c "mkinitcpio -P"
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
echo -e "${RED}A instalação foi finalizada${NC}
${RED}Encerrando script, lembre-se\n de sair do arch-chroot e desmontar as partições (exit e umount -R /mnt)${NC}"
