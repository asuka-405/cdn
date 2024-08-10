pacman -Sy
pacman -S neovim zsh networkmanager grub efibootmgr os-prober ntfs-3g amd-ucode --noconfirm

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
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg


echo "KEYMAP=us" > /etc/vconsole.conf
echo "arch" > /etc/hostname

pacman -S plasma kitty sddm --noconfirm