#!/bin/bash

clear
     echo "Eu não me responsabilizo por qualquer uso indevido"
     echo "deste script, ele foi criado para"
     echo "uso pessoal e armazenado publicamente no github. by @pedrkw"
     echo "e armazenado publicamente no github. @pedrkw"
     echo "SCRIPT FEITO PARA USAR EM MODO BIOS/MBR/LEGACY!!"
     echo "QUALQUER DUVIDA EXTRA EU INDICO E RECOMENDO QUE USE O"
     echo "SITE OFICIAL archlinux.org"

sleep 10

reset

     echo "Configurando teclado"
     ls /usr/share/kbd/keymaps/**/*.map.gz
     echo "Digite o layout do seu teclado"
     echo "Exemplo: br-abnt2"
     read teclado
loadkeys $teclado
     echo "Teclado configurado"
sleep 02

clear
     echo "A seguir vamos definir a linguagem do ambiente live"
     echo "descomente a opção que corresponder a sua linguagem"
sleep 01

vim /etc/locale.gen

locale-gen
      echo "Arquivo Gerado com sucesso"
sleep 02

clear
      echo "Atualizando rélogio do sistema"
timedatectl set-ntp true
sleep 02

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

pacstrap /mnt base base-devel linux linux-firmware dhcpcd vim Networkmanager

         echo "Comando pacstrap executado com sucesso"
sleep 02

         echo "Gerando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
         echo "Fstab gerado com sucesso"
cat /mnt/etc/fstab

sleep 03

         echo "Entrando em chroot"
         echo "Definindo o fuso horario"
ls /usr/share/zoneinfo/
         echo "Digite sua região/cidade"
         echo "Exemplo: America/Sao_Paulo"
ln -sf /usr/share/zoneinfo/$fuso /etc/localtime
         echo "Fuso definido com sucesso"
sleep 02

clear
         echo "Sincronizando rélogio do hardware"
hwclock --systohc
         echo "Rélogio sincronizado"

clear
         echo "Definindo o idioma do sistema"
         echo "Defina o idioma do sistema"
         echo "Descomente a seguir o que corresponde"
         echo "a seu idioma"
         vim /etc/locale.gen

         echo "Gerando o locale"

         locale-gen

         cat /etc/locale.gen
         echo "Digite a seguir o que corresponde ao seu idioma"
         echo "Exemplo: pt_BR.UTF-8 (Para evitar erros tenha certeza de"
         echo "digitar a seu idioma corretamente)"
         read locale
         echo "$locale" > /etc/locale.conf
         echo "Concluido com sucesso"

clear
         echo "Defina o hosname (Nome da maquina/sistema)"
         read maquina
         echo "$maquina" > /etc/hostname

clear
         echo "Defina o layout do seu sistema"
         echo "Exemplo: br-abnt2"
         read keymap
         echo "KEYMAP=$keymap" > /etc/vconsole.conf

clear
         echo "Definindo a configuração de rede"
         echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts
         echo "::1 localhost.localdomain localhost" >> /etc/hosts
         echo "127.0.1.1 $maquina.localdomain" >> /etc/hosts

         echo "Você utiliza o sistema de IP permanente ?"
         echo "Seleciona a opção que lhe corresponder melhor"
         echo "1 - Sim"
         echo "2 - Não"
         read opcao
         if [ $opcao == "1" ];
         then
         echo "Então vamos voltar ao /etc/hosts"
         echo "Lá você vai editar os IP e substituir"
         echo "Pelo de seu uso, tome cuidado com as alterações"
         echo "Escolha entre o vim ou nano para editar o arquivo"
         echo "Se não souber qual escolher use o nano"
         read editor
         $editor /etc/hosts
         echo "Alterado com sucesso"
         elif [ $opcao == "2" ];
         then
         echo "Continuando o script..."
         sleep 01
         clear
         fi

         echo ""
         echo "nameserver 1.1.1.1" >> /etc/resolv.conf
         echo "nameserver 8.8.8.8" >> /etc/resolv.conf
         echo "Concluido"
         sleep 01

clear
         echo "A seguir vamos configurar para que o dhcpcd ou Networkmanager"
         echo "inicie junto do seu sistema quando a instalação finalizar"
         echo "Se você utiliza internet cabeada digite a seguir dhcpcd"
         echo "Caso use wifi digite a seguir NetworkManager (Por favor"
         echo "respeite as letras maisculas ou minusculas"
         read net
         systemctl enable $net

clear
         echo "Agora vamos pra a criação do seu usuario"
         echo "A seguir digite o nome do seu usuario"
         read nome
         useradd -m -g users -G log,sys,wheel,rfkill,dbus -s /bin/bash $nome
clear
         echo "A seguir digite a senha do seu usuario"
         echo "Ela não vai estar visivel mas vai estar"
         echo "sendo digitada, então tenha cuidado e calma"
         echo "no momento de digitar"
         echo "Digite a sua senha:"
         passwd $nome
         echo "Senha do $nome difinido/a com sucesso"
clear
         echo "Agora defina a senha do usuario ROOT"
         echo "Essa senha é bastante importante, portanto tome"
         echo "cuidado para não haver erros de digitação"
         passwd
clear
         echo "Descomentando a linha wheel em /etc/sudoers para"
         echo "permitir que os usuarios no grupo wheel tenha acesso"
         echo "ao poder de ROOT usando sudo"
         sed -i  '/wheel/ s/^#//' /etc/sudoers
         echo "Descomentado com sucesso"
clear
         echo "Instalando BOOTLOADER (GRUB)"
         mkinitcpio -P
         grub-install /dev/sda
         grub-mkconfig -o /boot/grub/grub.cfg
         echo "BOOTLOADER (GRUB) Instalado com sucesso"
         echo "Instalação concluida"
         exit
         umount -R /mnt
         reboot
