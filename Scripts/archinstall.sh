#!/bin/bash
timedatectl set-ntp true
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sdb1
mount /dev/sda1 /mnt
mkdir /mnt/hdlocal
chown -R pedrokw:users /mnt/hdlocal
pacstrap /mnt base base-devel linux-zen linux-firmware dhcpcd vim grub xorg-server xorg-apps
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash -c "dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress"
arch-chroot /mnt /bin/bash -c "chmod 600 /swapfile"
arch-chroot /mnt /bin/bash -c "mkswap /swapfile"
arch-chroot /mnt /bin/bash -c "swapon /swapfile"
arch-chroot /mnt /bin/bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
arch-chroot /mnt /bin/bash -c "echo /hdlocal"
vim /mnt/etc/fstab
arch-chroot /mnt /bin/bash -c "timedatectl set-ntp true"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i '/en_US.UTF-8/ s/^#//' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo 'LANG=en_US.UTF-8' > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo 'volt' >> /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo 'KEYMAP=br abnt2' > /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 localhost.localdomain localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '::1 localhost.localdomain localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '127.0.1.1 volt.localdomain' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo 'nameserver 1.1.1.1' >> /etc/resolv.conf"
arch-chroot /mnt /bin/bash -c "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
arch-chroot /mnt /bin/bash -c "systemctl enable dhcpcd"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel -s /bin/bash pedrokw"
arch-chroot /mnt /bin/bash -c "passwd pedrokw"
arch-chroot /mnt /bin/bash -c "passwd root"
arch-chroot /mnt /bin/bash -c "sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers"
arch-chroot /mnt /bin/bash -c "grub-install /dev/sda"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
echo -e "Finished.."