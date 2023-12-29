echo "Installing barebones kde..."
PKGS=(

    #KDE
    "xorg"
    "plasma-desktop"
    "plasma-wayland-session"
    "sddm"
    "sddm-kcm"

    #Pipewire audio
    "pipewire"
    "pipewire-alsa"
    "pipewire-media-session"
    "pipewire-pulse"

    #KDE applications
    "dolphin"
    "dolphin-plugins"
    "plasma-systemmonitor"
    "plasma-pa"
    "plasma-nm"
    "bluedevil"
    "konsole"
    "kate"
    "kamoso"

    #Extras
    "flameshot"
    "vlc"
    "chromium"
    "viewnior"
    "gimp"
    "p7zip"

)

for PKG in "${PKGS[@]}"; do
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo "Enabling services"
sudo systemctl enable sddm.service
sudo systemctl enable NetworkManager.service
sudo systemctl --user --now disable pulseaudio.service pulseaudio.socket
sudo systemctl --user mask pulseaudio
sudo systemctl --user --now enable pipewire pipewire-pulse pipewire-media-session

echo "Building yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

echo "Configuring ancient rt3290 bluetooth adapter"
yay -S rtbth-dkms-git --noconfirm
sudo systemctl enable bluetooth.service
sudo echo rtbth >> /etc/modules-load.d/rtbth.conf

echo "Installing ancient nvidia drivers"
yay -S nvidia-390xx-dkms nvidia-390xx-utils lib32-nvidia-390xx-utils --noconfirm
sudo pacman -S libglvnd opencl-nvidia lib32-libglvnd lib32-opencl-nvidia nvidia-settings --noconfirm --needed
sudo sh -c 'sed -i "s/^MODULES=().*/MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf'
mkinitcpio -P
grubConfig='s/^GRUB_CMDLINE_LINUX.*/GRUB_CMDLINE_LINUX="nvidia_drm.modeset=1 rd.driver.blacklist=nouveau modprob.blacklist=nouveau"/'
sudo sh -c "sed -i ${grubConfig} /etc/mkinitcpio.conf"
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkdir /etc/pacman.d/hooks
sudo bash -c  "cat <<EOT >> /etc/pacman.d/hooks/nvidia.hook 
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia-390xx-dkms
Target=linux-lts
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOT"

echo "Installing ancient intel drivers"
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel

echo "Set nvidia as default GPU"
yay -S envycontrol --noconfirm
sudo envycontrol -s nvidia --dm sddm

reboot now