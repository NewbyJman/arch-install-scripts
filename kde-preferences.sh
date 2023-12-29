echo "deleting default media"
sudo rm -r /usr/share/wallpapers/*
sudo rm -r /usr/share/plasma/wallpapers/*
sudo rm -r /usr/share/plasma/avatars/*
sudo mkdir /usr/share/gitMedia
sudo mv media/* user/share/gitMedia

echo "Deleting default sddm themes"
sudo rm -r /usr/share/sddm/themes/*

echo "Applying Nordic-bluish sddm theme"
cd /usr/share/sddm
sudo git clone https://github.com/EliverLara/Nordic.git
sudo mv Nordic/kde/sddm/Nordic-bluish themes/Nordic-bluish
sudo rm -r Nordic
sudo sed -i "s/^#Current=.*/Current=Nordic-bluish/" /etc/sddm.conf.d/kde_settings.conf

echo "Deleting default kde themes"
sudo rm -r /usr/share/plasma/desktoptheme/*     # plasma style
sudo rm -r /usr/share/plasma/look-and-feel/*    # global theme
sudo rm -r /usr/share/color-schemes/*           # colours

echo "Downloading Dracula-purple kde theme"
cd /usr/share/plasma
sudo git clone https://github.com/dracula/gtk.git
sudo mv gtk/kde/plasma/desktoptheme desktoptheme
sudo mv /usr/share/desktoptheme /usr/share/plasma/desktoptheme
sudo mv gtk/kde/plasma/look-and-feel look-and-feel
sudo mv gtk/kde/color-schemes /usr/share/color-schemes
sudo rm -r gtk

echo "Deleting default icons"


echo "Downloading Dexy-Color-Dark icons"
cd /usr/share/icons
sudo git clone https://github.com/L4ki/Dexy-Plasma-Themes.git
sudo mv Dexy-Plasma-Themes/Dexy-Color-Icons/Dexy-Color-Dark-Icons Dexy-Color-Dark-Icons
sudo rm -r Dexy-Plasma-Themes