#!/bin/bash
timedatectl set-ntp true
cp /etc/pacman.d/mirrorlist /etc/pacmand./mirrorlist.backup
reflector --verbose --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
cfdisk -z /dev/sda
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
pacstrap /mnt linux-zen linux-firmware base base-devel dhcpcd vim grub xorg-apps xorg-server xorg-xinit
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash -c "dd if=/dev/zero of=/swapfile bs=1MB count=4096 status=progress"
arch-chroot /mnt /bin/bash -c "chmod 600 /swapfile"
arch-chroot /mnt /bin/bash -c "mkswap /swapfile"
arch-chroot /mnt /bin/bash -c "swapon /swapfile"
arch-chroot /mnt /bin/bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
arch-chroot /mnt /bin/bash -c "timedatectl set-ntp true"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i /en_US.UTF-8/ s/^#// /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo -e LANG=en_US.UTF-8 > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo -e volt >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo -e KEYMAP-br abnt2 >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo -e 127.0.0.1 localhost >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo -e ::1 localhost >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo -e nameserver 8.8.8.8 >> /etc/resolv.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable dhcpcd"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -s /bin/bash pedrokw"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
arch-chroot /mnt /bin/bash -c "passwd root"
arch-chroot /mnt /bin/bash -c "pacman -S vi"
arch-chroot /mnt /bin/bash -c "visudo /etc/sudoers"
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
