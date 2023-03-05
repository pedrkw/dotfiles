#!/bin/bash
# find the current user.
whoami=$(whoami)
 
            echo -e "Insira o caminha da iso para gravar"
            echo -e "Por exemplo: ~/Downloads/archlinux.iso"
            read iso
            
            echo -e "Se não sabe qual a partição do drive a ser usado"
            echo -e "escolha qual vai ser o drive a ser usado" 
lsblk      
            echo -e "Informe qual o drive para ser usado"
            echo -e "exemplo: /dev/sdx (troque o x pela letra correspondente "
            read devsda
            
            echo -e "A iniciar a gravação, aguarde."
dd if=$iso of=$devsda bs=4M oflag=sync status=progress

            echo -e "Gravação terminada."

sleep 02
