#!/bin/bash
echo "Script feito para baixar"
echo "audio ou video by @pedrkw"
echo "Selecione uma opção:"
echo "1 - Baixar vídeo"
echo "2 - Baixar audío"
read opcao;
if [ $opcao == "1" ];
then
 echo "Cole a URL/link do vídeo"
 read video
 youtube-dl $video
 echo "Download concluido, o arquivo foi baixado com sucesso"
elif [ $opcao == "2" ];
 then
 echo "Cole a URL/link do vídeo "
 read audio
 youtube-dl --extract-audio --audio-format mp3 $audio
 echo "Download concluido, o arquivo foi baixado com sucesso"
fi
