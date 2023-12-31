# Import media
sudo mkdir /usr/share/gitMedia
sudo mv /home/zaib/arch-install-scripts/media/* /usr/share/gitMedia/

# Configure SDDM
echo "Downloading Nordic-bluish sddm theme"
cd /usr/share/sddm
sudo git clone https://github.com/EliverLara/Nordic.git
sudo mv Nordic/kde/sddm/Nordic-bluish themes/Nordic-bluish
sudo rm -r Nordic

sudo bash -c 'sed -i "s/^Current=.*/Current=Nordic-bluish/" /lib/sddm/sddm.conf.d/default.conf'
sudo bash -c 'sed -i "s/^CursorTheme=.*/CursorTheme=Dracula-cursors/" /lib/sddm/sddm.conf.d/default.conf'

# Download global theme, cursors, icons
echo "Downloading Dracula-purple kde theme"
cd /usr/share/themes
sudo mkdir Dracula
sudo git clone https://github.com/dracula/gtk.git
sudo mv gtk/kde/cursors/Dracula-cursors /usr/share/icons
sudo rm -r gtk

yay -Syy dracula-gtk-theme --noconfirm --removemake --noanswerclean --noanswerdiff

echo "Downloading Lavender-Light-Icons icons"
cd /usr/share/icons
sudo git clone https://github.com/L4ki/Lavender-Plasma-Themes.git
sudo mv Lavender-Plasma-Themes/Lavender-Icons/Lavender-Light-Icons Lavender-Light-Icons
sudo rm -r Lavender-Plasma-Themes

# Configure global theme, cursor, icons
xfconf-query -c xsettings -p /Net/ThemeName -s "Dracula"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Dracula-cursors"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Lavender-Light-Icons"
xfconf-query -c xsettings -p /Gtk/FontName -s "System-ui 10"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Nimbus Sans 10"

# Configure desktop
desktopQuery=$(xfconf-query -c xfce4-desktop-l)
IFS=" " read -r -a dArr <<< desktopQuery
dProp="${dArr[0]:0:45}"
xfconf-query -c xfce4-desktop -p  "${dProp}last-image" -s /usr/share/gitMedia/wallpaperBorder.png
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -s "true"

# Import remaining conf files
cd /home/zaib/arch-install-scripts
sudo mv -f configs/parcellite/* /home/zaib/.config/parcellite/
sudo mv -f configs/xfce4/panel/* /home/zaib/.config/xfce4/panel
sudo mv -f configs/xfce4/xfconf/xfce-perchannel-xml/* /home/zaib/.config/xfce4/xfconf/xfce-perchannel-xml/

sudo rm -r /home/zaib/arch-install-scripts