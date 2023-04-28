#!/bin/bash

# Verificar se o pacote youtube-dl está instalado
if ! command -v youtube-dl &> /dev/null; then
    echo "O pacote 'youtube-dl' não está instalado. Por favor, instale-o antes de executar este script."
    exit 1
fi

while true; do
    echo "Bem-vindo ao script de download do YouTube"
    echo "Por favor, insira o link do vídeo ou da playlist que deseja baixar: "
    read url

    echo "Deseja baixar um vídeo ou áudio? (Digite 'v' para vídeo ou 'a' para áudio): "
    read media_type

    if [ "$media_type" = "v" ]; then
      echo "Listando resoluções disponíveis:"
      youtube-dl -F $url | grep -E '^[0-9]+\s+(mp4|webm|flv|3gpp)' | awk '{print $1 " - " $2}'
      echo "Por favor, escolha a resolução que deseja baixar: "
      read res
      if ! youtube-dl -f $res $url; then
          echo "Falha ao baixar o vídeo. Certifique-se de que escolheu uma resolução válida."
          exit 1
      fi
    elif [ "$media_type" = "a" ]; then
      echo "Listando formatos de áudio disponíveis:"
      youtube-dl -F $url | grep 'audio only' | awk '{print $1 " - " $2}'
      echo "Por favor, escolha o formato de áudio que deseja baixar: "
      read audio_format
      if ! youtube-dl -f $audio_format $url; then
          echo "Falha ao baixar o áudio. Certifique-se de que escolheu um formato de áudio válido."
          exit 1
      fi
    else
      echo "Tipo de mídia inválido"
      exit 1
    fi

    echo "Deseja baixar outro vídeo ou áudio? (Digite 's' para sim ou 'n' para não):"