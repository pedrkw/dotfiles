#!/bin/bash

clear
     echo "   Eu não me responsabilizo por qualquer uso indevido            "
     echo "   deste script, ele foi criado para                             "
     echo "   uso pessoal e armazenado publicamente no github. by @pedrkw   "
     echo "   e armazenado publicamente no github. @pedrkw                  "
     echo "   SCRIPT FEITO PARA USAR EM MODO BIOS/MBR/LEGACY!!              "
     echo "   QUALQUER DUVIDA EXTRA EU INDICO E RECOMENDO QUE USE O         "
     echo "   SITE OFICIAL archlinux.org"

sleep 10

reset

     echo "Configurando teclado"
loadkeys br-abnt2
     echo "Teclado configurado"
sleep 01

clear
     echo "A seguir vamos definir a linguagem do ambiente live"
     echo "descomente a opção que corresponder a sua linguagem"
sleep 01

sed -i  '/pt_BR/,+1 s/^#//' /etc/locale.gen
locale-gen
      echo "Arquivo Gerado com sucesso"
sleep 01

clear
      echo "Atualizando rélogio do sistema"
timedatectl set-ntp true
sleep 01

clear
       echo "Iniciando o particionado"
cfdisk
       echo "Formatando partições"
clear
lsblk
       echo "Informe as devidas partições"
       echo "Exemplo: /dev/sdaX"
       echo "Partição ROOT"
       read root

mkfs.ext4 $root

       echo "Partição SWAP"
       echo "Exemplo: /dev/sdaX"
       read swap

mkswap $swap
swapon $swap

       echo "Partição HOME"
       echo "Exemplo /dev/sdaX"
       read home

mkfs.ext4 $home

       echo "Formatação Concluída"
sleep 02

        echo "Montando sistema de arquivos"

mount $root /mnt
mkdir /mnt/home
mount $home /mnt/home

        echo "Montagem concluída"
sleep 02

clear
        echo "Iniciando a instalação dos pacotes essenciais"

pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim

         echo "Comando pacstrap executado com sucesso"
sleep 01

         echo "Gerando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
         echo "Fstab gerado com sucesso"
cat /mnt/etc/fstab
sleep 01

clear
         echo "Primeira parte realizada com sucesso, agora"
         echo "entre em arch-chroot /mnt e rode o segundo script"
clear
