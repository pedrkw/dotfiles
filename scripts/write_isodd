#!/bin/bash
#find the current user
whoami=$(whoami)

#ask for iso file path
echo -e "Insira o caminho da ISO para gravar"
echo -e "Por exemplo: ~/Downloads/archlinux.iso"
read iso

#verify iso path
if [ ! -f $iso ]; then
echo "O caminho do arquivo ISO é inválido. Por favor, verifique e tente novamente."
exit 1
fi

#list available devices and ask for device to be used
echo -e "Se não sabe qual a partição do drive a ser usado"
echo -e "escolha qual vai ser o drive a ser usado"
lsblk
echo -e "Informe qual o drive para ser usado"
echo -e "exemplo: /dev/sdx (troque o x pela letra correspondente) "
read devsda

#verify device path
if [ ! -b $devsda ]; then
echo "O caminho do dispositivo é inválido. Por favor, verifique e tente novamente."
exit 1
fi

#ask for confirmation before starting the copy process
echo -e "Você tem certeza de que deseja iniciar a gravação do ISO em $devsda?"
read -p "Digite 'sim' para confirmar: " confirmation

if [ "$confirmation" != "sim" ]; then
echo "A gravação do ISO foi cancelada."
exit 1
fi

#verify write permission
if [ ! -w $devsda ]; then
echo "Você não tem permissão para gravar neste dispositivo. Por favor, execute o script como root ou como um usuário com permissão de gravação no dispositivo."
exit 1
fi

#start copy process
echo -e "Iniciando gravação, aguarde..."
dd if=$iso of=$devsda bs=4M oflag=sync status=progress

#print message when copy process is completed
echo -e "Gravação concluída."
