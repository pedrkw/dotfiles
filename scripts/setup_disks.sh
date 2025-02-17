#!/bin/bash

# Define colors for messages
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

# Display reminder to create UEFI partition
echo -e "${RED}Reminder: Ensure the UEFI partition is created${NC}"
read -p "Press Enter to continue..." 

# Set up partitions with cfdisk
cfdisk -z /dev/nvme0n1 || exit 1
cfdisk -z /dev/sda || exit 1 # OLD HDD
cfdisk -z /dev/sdc || exit 1 # NEW HDD
echo
lsblk -f
echo
read -p "Press Enter to continue..."

# Clear screen and configure physical volumes
clear
lvmdiskscan
pvcreate /dev/nvme0n1p2 || exit 1
pvcreate /dev/sda1 || exit 1
pvcreate /dev/sdc1 || exit 1
pvscan

# Confirm configuration
echo -e "Does this look${RED}correct${NC}?"
read -p "Type ${GREEN}yes${NC} or ${GREEN}no${NC}: " option

if [ "$option" == "yes" ]; then
    vgcreate entropy /dev/sda1 /dev/sdc1 /dev/nvme0n1p2 || exit 1
elif [ "$option" == "no" ]; then
    echo -e "${RED}Exiting...${NC}"
    exit 0
else
    echo -e "${RED}Invalid option. Exiting...${NC}"
    exit 1
fi

vgs
read -p "Press Enter to continue..."

# Create logical volumes
lvcreate -l 100%FREE entropy -n eroot /dev/nvme0n1p2 || exit 1
lvcreate -L 48G entropy -n ebackup /dev/sda1 || exit 1
# lvcreate -L 24G entropy -n wvarcache /dev/sdb1 || exit 1
lvcreate -L 8G entropy -n eswap /dev/sdc1 || exit 1
lvcreate -L 365G entropy -n ehddwd /dev/sdc1 || exit 1
read -p "Press Enter to continue..."
clear

# Activate volumes
modprobe dm_mod
vgscan
vgchange -ay

# Format file systems
mkfs.fat -F32 /dev/nvme0n1p1 || exit 1
mkfs.ext4 /dev/entropy/eroot || exit 1
mkfs.ext4 /dev/entropy/ebackup || exit 1
# mkfs.ext4 /dev/entropy/wvarcache || exit 1
mkfs.ext4 /dev/entropy/ehddwd || exit 1
mkswap /dev/entropy/eswap || exit 1

# Display formatted devices
echo -e "-"
lsblk -f
read -p "Press Enter to continue..."

# Mount volumes
mount /dev/entropy/eroot /mnt || exit 1
# mkdir -p /mnt/{var/cache,hdd,boot/efi}
mkdir -p /mnt/{/data/hddwd,boot/efi} || exit 1
mount /dev/nvme0n1p1 /mnt/boot/efi || exit 1
# mount /dev/entropy/wvarcache /mnt/var/cache || exit 1
mount /dev/entropy/ehddwd /mnt/data/hdd || exit 1
swapon /dev/entropy/wswap || exit 1

echo -e "${GREEN}Setup completed successfully!${NC}"