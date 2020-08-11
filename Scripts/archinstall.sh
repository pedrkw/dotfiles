#!/bin/bash
clear
RED='\033[1;31m'
NC='\033[0m'

echo -e "${RED}Script feito por @pedrkw(Telegram) ${NC}
${RED}não me resposabilizo por eventuais problemas${NC}
${RED}Iniciando script...                         ${NC}"
sleep 02
sed -i  '/pt_BR.UTF-8/ s/^#//' /etc/locale.gen
locale-gen
export LANG=pt_BR.UTF-8
timedatectl set-ntp true
clear
echo -e "${RED}Parte inicial executada com sucesso${NC}
${RED}Continuando o script...${NC}
Pressione a tecla ${RED}ENTER${NC} para continuar..."
read $tmp
clear
echo -e "Sincronizando espelhos usando o reflector, aguarde..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
clear
echo -e "${RED}A T E N Ç Ã O :${NC}
Esse script segue um certo padrão de particionamento\nao utilizar esse script você terá que ter uma partição /\numa partição /home\ne será criado um swapfile\n${RED}não se faz necessario ciar uma partição swap${NC}
Ele lhe dá a possibilidade de utilizar EXT4 ou BTRFS como sistema de arquivos
Pressione a tecla ${RED}ENTER${NC} para continuar..."
read $tmp
clear
echo -e "Deseja iniciar o particionador ?
Selecione uma opção (digite apenas o número que corresponde a opção desejada):
1 - Sim
2 - Não"
read opcao;
if [ $opcao == "1" ];
 then
 cfdisk
elif [ $opcao == "2" ];
 then
 echo "Prosseguindo o script..."
fi
clear
 lsblk
 echo -e "Informe o caminho da partição ${RED}ROOT${NC}
 Informe qual a partição. Ex: (/dev/sda2)"
 read root
clear
 lsblk
 echo -e "Informe o caminho da partição ${RED}HOME${NC}
 Informe qual a partição. Ex: (/dev/sda3)"
 read home
clear
echo -e "Informe o sistema de arquivos que deseja utilizar
Selecione uma opção (digite apenas o número que corresponde a opção desejada):"
echo "1 - BTRFS"
echo "2 - EXT4"
read opcao;
if [ $opcao == "1" ];
 then
 mkfs.btrfs -L root $root
 mkfs.btrfs -L home $home
 mount $root /mnt
 mkdir /mnt/home
 mount $home /mnt/home
 echo -e "Iniciando a instalação dos pacotes essenciais
 Por padrão esses serão os pacotes a serem instalados:\n${RED}base base-devel linux linux-firmware dhcpcd vim grub btrfs-progs${NC}
 Caso queira adicionar outros pacotes faça agora\nSe não quiser, apenas aperte ${RED}ENTER${NC} para prosseguir
 Digite os nomes ${RED}CORRETOS${NC} dos pacotes extras que você quer, lembre-se\nde respeitar os espaços entre os nomes dos pacotes" 
 read pacotes
 pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim grub btrfs-progs $pacotes
 echo -e "Gerando fstab..."
 genfstab -U /mnt >> /mnt/etc/fstab
 echo -e "Criando swapfile"
 arch-chroot /mnt /bin/bash -c "truncate -s 0 /swapfile"
 arch-chroot /mnt /bin/bash -c "chattr +C /swapfile"
 arch-chroot /mnt /bin/bash -c "btrfs property set /swapfile compression none"
 echo -e "Digite o tamanho do swapfile em mebibytes ou gibibytes. Ex:1024M ou 1G"
 read swapfi
 arch-chroot /mnt /bin/bash -c "fallocate -l $swapfi /swapfile"
 arch-chroot /mnt /bin/bash -c "chmod 600 /swapfile"
 arch-chroot /mnt /bin/bash -c "mkswap /swapfile"
 arch-chroot /mnt /bin/bash -c "swapon /swapfile"
 arch-chroot /mnt /bin/bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
elif [ $opcao == "2" ];
 then
 mkfs.ext4 $root
 mkfs.ext4 $home
 mount $root /mnt
 mkdir /mnt/home
 mount $home /mnt/home
 echo -e "Iniciando a instalação dos pacotes essenciais
 Por padrão esses serão os pacotes a serem instalados:\n${RED}base base-devel linux linux-firmware dhcpcd vim grub${NC}
 Caso queira adicionar outros pacotes faça agora/nSe não quiser, apenas aperte ${RED}ENTER${NC} para prosseguir
 Digite os nomes ${RED}CORRETOS${NC} dos pacotes extras que você quer, lembre-se\n de respeitar os espaços entre os nomes dos pacotes" 
 read pacotes
 pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim grub $pacotes
 echo -e "Gerando fstab..."
 genfstab -U /mnt >> /mnt/etc/fstab
 echo -e "Criando swapfile
 Digite o tamanho do swapfile em mebibytes ou gibibytes (Por favor, digite conforme os exemplos, \napenas altera o tamanho como quiser). Ex:1024M ou 1G"
 read swapfi
 arch-chroot /mnt /bin/bash -c "fallocate -l $swapfi /swapfile"
 arch-chroot /mnt /bin/bash -c "chmod 600 /swapfile"
 arch-chroot /mnt /bin/bash -c "mkswap /swapfile"
 arch-chroot /mnt /bin/bash -c "swapon /swapfile"
 arch-chroot /mnt /bin/bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
fi
clear
echo -e "${RED}Comando pacstrap executado com sucesso${NC}"
sleep 01
clear
echo -e "${RED}Entrando em arch-chroot${NC}
Escolha a região mais adequada para definir o fuso horário
Tenha cuidado com maiúsculas e minúsculas"
ls /usr/share/zoneinfo/America/
read zone
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/$zone /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i '/pt_BR.UTF-8/ s/^#//' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo 'LANG=pt_BR.UTF-8' > /etc/locale.conf"
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
