pacman -Sy
pacman -S neovim zsh networkmanager ntfs-3g amd-ucode --noconfirm

echo "en_IN UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc --utc

systemctl enable NetworkManager
systemctl enable fstrim.timer

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

echo "Enter root password"
passwd

read -p "Enter username: " username

useradd -m -g users -G wheel,storage,power -s /bin/zsh $username
echo "Enter password for $username"
passwd $username

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults rootpw" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers

bootctl --path=/boot install

read "grub or direct boot? (grub is better for dual boot) [g/d]: " boot

if [ $boot == "g" ]; then
    pacman -S grub efibootmgr os-prober --noconfirm
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    grub-mkconfig -o /boot/grub/grub.cfg
else
    mkdir -p /boot/loader/entries
    echo "title ArchLinux" > /boot/loader/entries/arch.conf
    echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
    echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
    echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/sda2) rw" >> /boot/loader/entries/arch.conf
fi



echo "KEYMAP=us" > /etc/vconsole.conf
echo "arch" > /etc/hostname

pacman -Sy plasma kitty sddm --noconfirm