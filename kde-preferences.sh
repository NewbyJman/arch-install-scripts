echo "Deleting default media"
sudo rm -r /usr/share/wallpapers/*
sudo rm -r /usr/share/plasma/wallpapers/*
# sudo rm -r /usr/share/plasma/avatars/*
sudo mkdir /usr/share/gitMedia
sudo mv media/* user/share/gitMedia

kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
--group Containments --group 3 --group Applets --group 3 \
--group Configuration --group General \
--key icon /hom/zaib/arch-install-scripts/media/ssjblue.ico

echo "Deleting default sddm themes"
# sudo rm -r /usr/share/sddm/themes/*

echo "Deleting default kde themes"
# sudo rm -r /usr/share/plasma/desktoptheme/*     # plasma style
# sudo rm -r /usr/share/plasma/look-and-feel/*    # global theme
# sudo rm -r /usr/share/color-schemes/*           # colours

echo "Downloading Silvery-Dark-Plasma style"
cd /usr/share/plasma
sudo git clone https://github.com/L4ki/Silvery-Plasma-Themes.git
sudo mv Silvery-Plasma-Themes/Silvery Plasma Themes/Silvery-Dark-Plasma/* desktoptheme/Silvery-Dark-Plasma

echo "Downloading Peace-Color-Splash"
cd /usr/share/plasma
sudo git clone https://github.com/L4ki/Peace-Plasma-Themes.git
sudo mv Peace-Plasma-Themes/Peace Splashscreens/Peace-Color-Splash look-and-feel/
sudo rm -r Peace-Plasma-Themes

echo "Downloading Nordic-bluish sddm theme"
cd /usr/share/sddm
sudo git clone https://github.com/EliverLara/Nordic.git
sudo mv Nordic/kde/sddm/Nordic-bluish themes/Nordic-bluish
sudo rm -r Nordic

echo "Downloading Dracula-purple kde theme"
cd /usr/share/plasma
sudo git clone https://github.com/dracula/gtk.git
sudo mv gtk/kde/plasma/desktoptheme/Dracula desktoptheme
sudo mv gtk/kde/plasma/look-and-feel/* look-and-feel
sudo mv gtk/kde/color-schemes/DraculaPurple /usr/share/color-schemes
sudo mv gtk/kde/cursors/* /usr/share/icons/Dracula-cursors
sudo rm -r gtk

echo "Downloading Lavender-Light-Icons icons"
cd /usr/share/icons
sudo git clone https://github.com/L4ki/Lavender-Plasma-Themes.git
sudo mv Lavender-Plasma-Themes/Lavender-Icons/Lavender-Light-Icons Lavender-Light-Icons
sudo rm -r Lavender-Plasma-Themes

# lockscreen config
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key Timeout 30
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key LockGrace 300
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key LockOnResume false
kwriteconfig5 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///home/zaib/arch-install-scripts/media/lockscreen.jpg"

# touchpad config
kwriteconfig5 --file ~/.config/touchpadxlibinputrc --group "SynPS/2 Synaptics TouchPad" --key disableWhileTyping false
kwriteconfig5 --file ~/.config/touchpadxlibinputrc --group "SynPS/2 Synaptics TouchPad" --key naturalScroll true
kwriteconfig5 --file ~/.config/touchpadxlibinputrc --group "SynPS/2 Synaptics TouchPad" --key tapToClick true

# mouse config
kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key XLbInptNaturalScroll true
kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key CursorTheme Dracula-cursors
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key ScrollbarLeftClickNavigatesByPage false
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key SingleClick false

# Apply SDDM theme
sudo bash -c 'sed sed -i "s/^Current=.*/Current=Nordic-bluish/" /etc/mkinitcpio.conf'
sudo bash -c 'sed sed -i "s/^CursorTheme=.*/CursorTheme=Dracula-cursors/" /etc/mkinitcpio.conf'

# Global settings
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key LookAndFeelPackage Dracula
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key widgetStyle Breeze
kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme DraculaPurple
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key theme kwin4_decoration_qml_plastik
kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme Lavender-Light-Icons
kwriteconfig5 --file ~/.config/plasmarc --group Theme --key name Silvery-Dark-Plasma
kwriteconfig5 --file ~/.config/plasmparc --group General --key RaiseMaximumVolume true
kwriteconfig5 --file ~/.config/ksplashrc --group KSplash --key Theme Peace-Color-Splash
