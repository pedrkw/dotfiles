#!/usr/bin/env bash
# this script NEED the pkg bc
# Início do cronômetro
start_time=$(date +%s.%N)

# Capturar os valores desejados
os=$(grep "^NAME=" /etc/os-release | awk -F'"' '{print $2}')
kernel=$(uname -r)
cpu="E5-2640 V3"
gpu="RX 6600"
ram=$(inxi -bGI | grep "^  Memory:" | awk -F"total: " '{print $2}' | awk '{print $1}')

# Exibir o resultado formatado
printf "OS: %s\n" "$os"
printf "Kernel: %s\n" "$kernel"
printf "CPU: %s\n" "$cpu"
printf "GPU: %s\n" "$gpu"
printf "RAM: %s GB\n" "$ram"
printf "GAME:\n"

# Fim do cronômetro
end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc)

# Exibir o tempo de execução
printf "\nScript took %.2f seconds to execute.\n" "$execution_time"
