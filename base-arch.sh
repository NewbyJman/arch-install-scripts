echo "Enter host name"
read hostName
echo "Enter username"
read userName
echo "Enter password"
read userPassword
echo "Enter Timezone (eg: Asia/Dubai)"
read timeZone

echo "-------------------------------------------------"
echo "Setting Time Zone"
timedatectl set-timezone $timeZone

echo "Creating Partitions (no swap)"

(
    # Delete existing partitions
    echo d
    echo d
    echo d
    echo g #Create new parition table

    # EFI partition
    echo n      # Add new parition
    echo 1      # Parition number
    echo        # First sector (default)
    echo +500M  # Last sector
    echo t
    echo 1      # Partition number
    echo 1      # Set to EFI

    # Root parition
    echo n      # Add new parition
    echo 2      # Parition number
    echo        # First sector (default)
    echo        # Last sector
    echo t
    echo 2      # Partition number
    echo 44      # Set to LVM

    #Write changes
    echo w
) | fdisk /dev/sda

echo "Formatting Partitions"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

echo "Mounting Partitions"
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

echo "Downloading linux base (lts)"
pacstrap -K /mnt base base-devel linux-lts linux-lts-headers linux-firmware vim git --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab


cat <<EOF > /mnt/postMount.sh
echo "Setting system clock"
ln -sf usr/share/zoneinfo/$timeZone /etc/localtime
hwclock --systohc

echo "Generating locales"
sed -i "s/^#en_GB.UTF-8 UTF-8.*/en_GB.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/^#en_GB ISO-8859-1.*/en_GB ISO-8859-1/" /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf

echo "Setting host"
echo $hostName >> /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1     localhost" >> /etc/hosts
echo "127.0.1.1     ${hostName}.localdomain     localhost" >> /etc/hosts
mkinitcpio -P

echo "Adding network, bluetooth, ssh, and grub"
pacman -Syu networkmanager grub efibootmgr bluez bluez-plugins bluez-utils openssh dkms  --noconfirm --needed
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable bluetooth
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Enabling multilib"
sed -i "s/^#VerbosePkgLists.*/VerbosePkgLists/" /etc/pacman.conf
sed -i "s/^#ParallelDownloads = .*/ParallelDownloads = 5/" /etc/pacman.conf
sed -i "/^ParallelDownloads = 5.*/a ILoveCandy" /etc/pacman.conf
sed -i "s/^#[multilib].*/[multilib]/" /etc/pacman.conf
sed -i "s/^#include = /etc/pacman.d/mirrorlist.*/include = /etc/pacman.d/mirrorlist/" /etc/pacman.conf
pacman -Syu

echo "Creating user: ${userName}"
echo $userName:$userPassword | chpasswd
sed '/^root All=(ALL:ALL) ALL.*/a ${userName} All=(ALL:ALL) ALL' /etc/sudoers

EOF
arch-chroot /mnt sh postMount.sh
umount -R /mnt
shutdown now
