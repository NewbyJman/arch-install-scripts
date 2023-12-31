PKGS=(
    # LightDM
    "sddm"

    # XFCE
    "xfce4 --ignore exo --ignore garcon --ignore xfce4-appfinder --ignore xfwm4-themes"
    "xfce4-goodies --ignore xfce4-clipman-plugin --ignore parole --ignore xfce4-screenshooter --ignore ristretto --ignore xburn --ignore xfce4-artwork --ignore xfce4-dict --ignore xfce4-eyes-plugin --ignore xfce4-diskperf-plugin --ignore xfce4-fsguard-plugin --ignore xfce4-genmon-plugin --ignore xfce4-mailwatch-plugin --ignore xfce4-mount-plugin --ignore xfce4-mpc-plugin --ignore xfce4-netload-plugin --ignore xfce4-notes-plugin --ignore xfce4-sensors-plugin --ignore xfce4-smartbookmark-plugin --ignore xfce4-systemload-plugin --ignore xfce4-time-out-plugin  --ignore xfce4-verve-plugin --ignore xfce4-weather-plugin"
    "nm-connection-editor"
    
    #Pipewire audio
    "pipewire"
    "pipewire-alsa"
    "pipewire-media-session"
    "pipewire-pulse"

    #Extras
    "flameshot"
    "parcellite"
    "vlc"
    "chromium"
    "viewnior"
    "gimp"
    "p7zip"
    "blueman"
    "pavucontrol"
)

# PKGS=(

#     #KDE
#     "xorg"
#     "plasma-desktop"
#     "plasma-wayland-session"
#     "sddm"
#     "sddm-kcm"
#     "kamoso"

#     #Pipewire audio
#     "pipewire"
#     "pipewire-alsa"
#     "pipewire-media-session"
#     "pipewire-pulse"

#     #KDE applications
#     "dolphin"
#     "dolphin-plugins"
#     "plasma-systemmonitor"
#     "plasma-pa"
#     "plasma-nm"
#     "bluedevil"
#     "konsole"
#     "kate"
#     "kamoso"

#     #Extras
#     "flameshot"
#     "vlc"
#     "chromium"
#     "viewnior"
#     "gimp"
#     "p7zip"

# )

for PKG in "${PKGS[@]}"; do
    sudo pacman -S $PKG --noconfirm --needed
done

echo "Enabling services"
sudo systemctl enable sddm
sudo systemctl enable NetworkManager.service
sudo systemctl --user --now disable pulseaudio.service pulseaudio.socket
sudo systemctl --user mask pulseaudio
sudo systemctl --user --now enable pipewire pipewire-pulse pipewire-media-session

echo "Building yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

echo "Downloading yay applets"
yay -S mugshot xfce4-docklike-plugin --noconfirm --noremovemake --noanswerclean --noanswerdiff

echo "Configuring ancient rt3290 bluetooth adapter"
yay -S rtbth-dkms-git --noconfirm --removemake --noanswerclean --noanswerdiff
sudo systemctl enable bluetooth.service
sudo sh -c 'sudo echo rtbth >> /etc/modules-load.d/rtbth.conf'

echo "Installing ancient nvidia drivers"
yay -S nvidia-390xx-dkms nvidia-390xx-utils lib32-nvidia-390xx-utils --noconfirm --removemake --noanswerclean --noanswerdiff
sudo pacman -S libglvnd opencl-nvidia lib32-libglvnd lib32-opencl-nvidia nvidia-settings --noconfirm --needed
sudo sh -c 'sed -i "s/^MODULES=().*/MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf'
mkinitcpio -P
sudo sh -c "sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"nvidia_drm.modeset=1 rd.driver.blacklist=nouveau modprob.blacklist=nouveau\"/' /etc/default/grub"
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
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel --noconfirm --needed

echo "Set nvidia as default GPU"
yay -S envycontrol --noconfirm --noremovemake --noanswerclean --noanswerdiff
sudo envycontrol -s nvidia --dm sddm

sudo reboot now
