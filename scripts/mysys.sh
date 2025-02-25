# Capture my system information
os=$(grep "^NAME=" /etc/os-release | awk -F'"' '{print $2}')
kernel=$(uname -r)
cpu=$(lscpu | awk -F': ' '/Model name/ {print $2}' | sed 's/^ *//')
gpu=$(lspci | grep -i ' vga ' | sed -E 's/.*\[AMD\/ATI\] Navi 23 \[//; s/\/.*//')
ram=$(inxi -bGI | grep "^  Memory:" | awk -F"total: " '{print $2}' | awk '{print $1}')
mesa=$(pacman -Q mesa | awk -F':' '{print $2}')

# Display the formatted output
printf "OS: %s\n" "$os"
printf "KERNEL: %s\n" "$kernel"
printf "CPU: %s\n" "$cpu"
printf "GPU: %s\n" "$gpu"
printf "MESA: %s\n" "$mesa"
printf "RAM: %s GB\n" "$ram"
printf "GAME:\n"