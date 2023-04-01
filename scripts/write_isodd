#!/bin/bash

# Find the current user.
whoami=$(whoami)

# Ask for ISO file path.
echo "Please enter the path to the ISO file to copy."
echo "For example: ~/Downloads/archlinux.iso"
read iso

# Verify ISO path.
if [ ! -f "$iso" ]; then
    echo "The ISO file path is invalid. Please check and try again."
    exit 1
fi

# List available devices and ask for device to be used.
echo "If you don't know which drive partition to use, choose which drive to use."
lsblk
echo "Please enter the drive path to use."
echo "For example: /dev/sdx (replace x with the corresponding letter)"
read drive

# Verify device path.
if [ ! -b "$drive" ]; then
    echo "The device path is invalid. Please check and try again."
    exit 1
fi

# Ask for confirmation before starting the copy process.
echo "Are you sure you want to start copying the ISO to $drive?"
echo "Type 'yes' to confirm or any other key to cancel."
read -r confirm

if [ "$confirm" != "yes" ]; then
    echo "The ISO copy process was canceled."
    exit 1
fi

# Verify write permission.
if [ ! -w "$drive" ]; then
    echo "You don't have write permission for this device. Please run the script as root or as a user with write permission on the device."
    exit 1
fi

# Start copy process.
echo "Starting copy process, please wait..."
dd if="$iso" of="$drive" bs=4M oflag=sync status=progress

# Print message when copy process is completed.
echo "ISO copy process completed."
