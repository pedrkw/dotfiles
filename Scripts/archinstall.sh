#!/bin/bash
clear

RED='\033[1;31m'
NC='\033[0m'

echo -e "${RED}Script feito por @pedrkw(Telegram)          ${NC}"
echo -e "${RED}não me resposabilizo por eventuais problemas${NC}"
echo -e "${RED}Iniciando script...                         ${NC}"
sleep 05

loadkeys br-abnt2
sed -i  '/pt_BR.UTF-8/ s/^#//' /etc/locale.gen
locale-gen
timedatectl set-ntp true
clear
echo -e "${RED}Parte inicial executada com sucesso${NC}"
echo -e "${RED}Continuando o script...${NC}"
echo -e "Pressione a tecla ${RED}ENTER${NC} para continuar..."
read $tmp
clear
echo -e "${RED}A T E N Ç Ã O :${NC}"
echo -e "Esse script segue um certo padrão de particionamento\nao utilizar esse script você terá que ter uma partição /\numa partição /home\ne uma partição swap\n${RED}no futuro, serão adicionas novas possibilidades${NC}"
echo -e "Ele lhe dá a possibilidade de utilizar EXT4 ou BTRFS como sistema de arquivos"
read $tmp
clear
echo -e "Deseja iniciar o particionador ?"
echo -e "Selecione uma opção (digite apenas o número que corresponde a opção desejada):"
echo "1 - Sim"
echo "2 - Não"
read opcao;
if [ $opcao == "1" ];
 then
 cfdisk
elif [ $opcao == "2" ];
 then
 echo "Prosseguindo o script..."
fi
clear
echo -e "Informe o caminho da partição swap"
 lsblk
 echo -e "Informe qual a partição. Ex: (/dev/sda1)"
 read swap
clear
echo -e "Informe o caminho da partição /"
 lsblk
 echo -e "Informe qual a partição. Ex: (/dev/sda2)"
 read root
clear
echo -e "Informe o caminho da partição /home"
 lsblk
 echo -e "Informe qual a partição. Ex: (/dev/sda3)"
 read home
clear
echo -e "Informe o sistema de arquivos que deseja utilizar"
echo -e "Selecione uma opção (digite apenas o número que corresponde a opção desejada):"
echo "1 - BTRFS"
echo "2 - EXT4"
read opcao;
if [ $opcao == "1" ];
 then
 mkfs.btrfs -L root $root
 mkfs.btrfs -L home $home
 mkswap $swap
 swapon $swap
 mount $root /mnt
 mkdir /mnt/home
 mount $home /mnt/home
elif [ $opcao == "2" ];
 then
 mkfs.ext4 $root
 mkfs.ext4 $home
 mkswap $swap
 swapon $swap 
 mount $root /mnt
 mkdir /mnt/home
 mount $home /mnt/home
fi
clear
echo -e "Iniciando a instalação dos pacotes essenciais"
echo -e "Por padrão esses serão os pacotes a serem instalados:\n${RED}base base-devel linux linux-firmware dhcpcd vim grub${NC}"
echo -e "Se você deseja adicionar pacotes extras, selecione a opção ${RED}SIM${NC}"
echo -e "Se não quiser adicionar pacotes extras, selecione a opção ${RED}NÃO${NC}"
echo -e "Selecione uma opção (digite apenas o número que corresponde a opção desejada):"
echo "1 - Sim, quero adicionar pacotes extras"
echo "2 - Não, não quero adicionar pacotes extras"
read opcao;
if [ $opcao == "1" ];
 then
 echo -e "Digite os nomes ${RED}CORRETOS${NC} dos pacotes extras que você quer, lembre-se\n de respeitar os espaços entre os pacotes "
 read pacotes
 echo -e "Executando pacstrap..."
 pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim grub $pacotes
elif [ $opcao == "2" ];
 then
 echo -e "Prosseguindo o script... executando pacstrap"
 pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim grub
fi
clear
echo -e "${RED}Comando pacstrap executado com sucesso${NC}"
echo -e "Gerando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "Fstab gerado com sucesso"
cat /mnt/etc/fstab
sleep 05
clear
echo -e "${RED}Entrando em arch-chroot${NC}"
echo -e "Escolha a região mais adequada para definir o fuso horário"
echo -e "Tenha cuidado com maiúsculas e minúsculas"
ls /usr/share/zoneinfo/America/
read zone
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/$zone /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i  '/pt_BR.UTF-8/ s/^#//' /etc/locale.gen"
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
echo -e "Digite o ${RED}nome do seu usuário${NC}"
read user
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel -s /bin/bash $user"
echo -e "Digite a senha do ${RED}SEU USUÁRIO${NC} a seguir"
echo -e "Para prosseguir e digitar a senha, pressione a tecla ${RED}ENTER${NC}"
read $tmp
arch-chroot /mnt /bin/bash -c "passwd $user"
echo -e "Digite a senha do ${RED}USUÁRIO ROOT${NC} a seguir"
echo -e "Para prosseguir e digitar a senha, pressione a tecla ${RED}ENTER${NC}"
read $tmp
arch-chroot /mnt /bin/bash -c "passwd root"
arch-chroot /mnt /bin/bash -c "sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers"
arch-chroot /mnt /bin/bash -c "mkinitcpio -P"
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
echo -e "${RED}A instalação foi finalizada${NC}"
echo -e "${RED}Encerrando script, lembre-se\n de sair do arch-chroot e desmontar as partições (exit e umount -R /mnt)${NC}"