# Import media
sudo mkdir -p ~/.local/share/gitMedia
sudo cp -f ~/arch-install-scripts/media/* ~/.local/share/gitMedia/

# Configure SDDM
echo "Downloading sddm theme"
cd /usr/share/sddm/themes
sudo rm -r /usr/share/sddm/themes/*
sudo git clone https://github.com/MarianArlt/sddm-chili.git
sudo bash -c 'echo "[Theme]" >> /usr/lib/sddm/sddm.conf.d/sddm.conf'
sudo bash -c 'echo "Current=sddm-chili" >> /usr/lib/sddm/sddm.conf.d/sddm.conf'
sudo bash -c 'sed -i "s/^Current=.*/Current=sddm-chili/" /lib/sddm/sddm.conf.d/default.conf'
sudo bash -c 'sed -i "s/^CursorTheme=.*/CursorTheme=Dracula-cursors/" /lib/sddm/sddm.conf.d/default.conf'
sudo cp ~/.local/share/gitMedia/gintoki.png /usr/share/sddm/faces/zaib.face.icon
sudo cp ~/.local/share/gitMedia/gintoki.png ~/.face
sudo cp -f ~/.local/share/gitMedia/lockscreen.jpg /usr/share/sddm/themes/sddm-chili/assets/background.jpg
sudo cp -f ~/arch-install-scripts/configs/sddm/svg/* /usr/share/sddm/themes/sddm-chili/assets/
sudo cp -f ~/arch-install-scripts/configs/sddm/Main.qml /usr/share/sddm/themes/sddm-chili/

# Download global theme, cursors, icons
echo "Downloading Dracula-purple kde theme"
cd /usr/share/themes
sudo mkdir -p Dracula
sudo git clone https://github.com/dracula/gtk.git
sudo mv -f gtk/kde/cursors/Dracula-cursors /usr/share/icons
sudo rm -r gtk

yay -Syy dracula-gtk-theme --noconfirm --removemake --noanswerclean --noanswerdiff

echo "Downloading Lavender-Light-Icons icons"
cd /usr/share/icons
sudo git clone https://github.com/L4ki/Lavender-Plasma-Themes.git
sudo mv -f Lavender-Plasma-Themes/Lavender-Icons/Lavender-Light-Icons Lavender-Light-Icons
sudo rm -r Lavender-Plasma-Themes

# Configure global theme, cursor, icons
xfconf-query -c xsettings -p /Net/ThemeName -n -t string -s "Dracula"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -n -t string -s "Dracula-cursors"
xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s "Lavender-Light-Icons"
xfconf-query -c xsettings -p /Gtk/FontName -n -t string -s "System-ui 10"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -n -t string -s "Nimbus Sans 10"
xfconf-query -c xfwm4 -p /general/theme -s "Default"
xfconf-query -c xfwm4 -p /general/title_alignment -s "left"
xfconf-query -c xfwm4 -p /general/title_font -s "System-ui Bold 11"
xfconf-query -c xfwm4 -p /general/snap_to_border -s true
xfconf-query -c xfwm4 -p /general/snap_to_windows -s true
xfconf-query -c xfwm4 -p /general/snap_width -s 10
xfconf-query -c xfwm4 -p /general/wrap_windows -s false
xfconf-query -c xfwm4 -p /general/wrap_workspaces -s false
xfconf-query -c xfwm4 -p /general/workspace_count -s 1
xfconf-query -c xfwm4 -p /general/wrap_resistance -s 10
xfconf-query -c xfwm4 -p /general/double_click_action -s "maximize"

# Configure desktop
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0 -n -t "string" -s "replace me"
# xfconf-query -c xfce4-desktop -p /desktop-icons -n -t "string" -s "replace me"
# xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons -n -t "string" -s "replace me"
# sed -i 's/type="string" value="replace me"/type="empty"/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -n -t string -s ~/.local/share/gitMedia/wallpaper.png
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-show -n -t bool -s true
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -n -t int -s 5
# xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -n -t bool -s false
# xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -n -t bool -s false
# xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -n -t bool -s false
# xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -n -t bool -s true
sudo cp -f ~/arch-install-scripts/configs/nitrogen/* ~/.config/nitrogen/

# Docklike Taskbar
mkdir -p ~/.config/xfce4/panel
cat <<EOT >> ~/.config/xfce4/panel/docklike-2.rc
    [user]
    showPreviews=true
    indicatorStyle=1
    inactiveIndicatorStyle=1
    forceIconSize=true
    iconSize=32
    keyComboActive=true
EOT

# Keymap mapping
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -r -R
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -n -t "string" -s "replace me"
sed -i 's/type="string" value="replace me"/type="empty"/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/override -n -t bool -s true
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"Print" -n -t string -s "flameshot gui"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Super>p" -n -t string -s "xfce4-display-settings --minimal"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Primary><Shift>Escape" -n -t string -s "lxtask"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Super>l" -n -t string -s "xfce4-session-logout"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Primary>Super_L" -n -t string -s "xfce4-popup-whiskermenu"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Alt>Return" -n -t string -s "rofi -show dmenu"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Super>e" -n -t string -s "nemo"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Super>t" -n -t string -s "xfce4-terminal"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/"<Alt>b" -n -t string -s "chromium --incognito google.co.uk"
sudo cp -f ~/arch-install-scripts/configs/parcelliterc ~/.config/parcellite/

# power management and screensaver
echo "screensaver"
xfconf-query -c xfce4-screensaver -p /lock -n -t "string" -s "replace me"
xfconf-query -c xfce4-screensaver -p /saver -n -t "string" -s "replace me"
sed -i 's/type="string" value="replace me"/type="empty"/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml
xfconf-query -c xfce4-screensaver -p /lock/sleep-activation -n -t bool -s false
xfconf-query -c xfce4-screensaver -p /lock/enabled -n -t bool -s false
xfconf-query -c xfce4-screensaver -p /saver/mode -n -t int -s 0
xfconf-query -c xfce4-screensaver -p /saver/enabled -n -t bool -s false

echo "session management"
xfconf-query -c xfce4-session -p /general/SaveOnExit -n -t bool -s false
xfconf-query -c xfce4-session -p /sessions/shutdown -r -R
xfconf-query -c xfce4-session -p /sessions/shutdown -n -t "string" -s "replace me"
sed -i 's/type="string" value="replace me"/type="empty"/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
xfconf-query -c xfce4-session -p /sessions/shutdown/LockScreen -n -t bool -s false

echo "power management"
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager -r -R
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager -n -t "string" -s "replace me"
sed -i 's/type="string" value="replace me"/type="empty"/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/brightness-store-restore-on-exit -n -t int -s 1
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/brightness-store -n -t bool -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lock-screen-suspend-hibernate -n -t bool -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-ac -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -n -t uint -s 14
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-sleep -n -t uint -s 13
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -n -t int -s 10

# Notifications
echo "Notifications"
xfconf-query -c xfce4-notifyd -p /plugin -n -t "string" -s "replace me"
sed -i 's/type="string" value="replace me"/type="empty"/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
xfconf-query -c xfce4-notifyd -p /plugin/hide-on-read -n -t bool -s true
xfconf-query -c xfce4-notifyd -p /plugin/log-icon-size -n -t int -s 15
xfconf-query -c xfce4-notifyd -p /plugin/log-only-today -n -t bool -s true
xfconf-query -c xfce4-notifyd -p /log-max-size-enabled -n -t bool -s true

# Mouse and touchpad
cat <<EOT >> ~/.config/xfce4/xfconf/xfce-perchannel-xml/pointers.xml
    <?xml version="1.0" encoding="UTF-8"?>

    <channel name="pointers" version="1.0">
    <property name="SynPS2_Synaptics_TouchPad" type="empty">
        <property name="RightHanded" type="bool" value="true"/>
        <property name="ReverseScrolling" type="bool" value="true"/>
        <property name="Threshold" type="int" value="1"/>
        <property name="Acceleration" type="double" value="5"/>
    </property>
    </channel>
EOT

# /us/share/X11/xorg.conf.d/40-libinput.conf
# option "VertScrollDelta" "-100"
# option "HorizScrollDelta" "-100"
# option "TapButton1" "1"
# option "TapButton2" "3"

# rofi
echo "rofi"
sudo rm -rf /usr/share/rofi/themes/*
sudo cp ~/arch-install-scripts/configs/zaib.rasi /usr/share/rofi/themes/
sudo mkdir -p ~/.config/rofi
sudo echo '@theme "/usr/share/rofi/themes/zaib.rasi"' >> ~/.config/rofi/config.rasi

# Terminal
echo "terminal"
xfconf-query -c xfce4-terminal -p /misc-cursor-shape -n -t string -s "TERMINAL_CURSOR_SHAPE_IBEAM"
xfconf-query -c xfce4-terminal -p /misc-cursor-blinks -n -t bool -s true
xfconf-query -c xfce4-terminal -p /font-use-system -n -t bool -s false
xfconf-query -c xfce4-terminal -p /font-name -n -t string -s "Source Code Pro Medium 15"
xfconf-query -c xfce4-terminal -p /font-allow-bold -n -t bool -s true
xfconf-query -c xfce4-terminal -p /background-mode -n -t string -s "TERMINAL_BACKGROUND_TRANSPARENT"
xfconf-query -c xfce4-terminal -p /background-darkness -n -t double -s 0.9
xfconf-query -c xfce4-terminal -p /misc-menubar-default -n -t bool -s true
xfconf-query -c xfce4-terminal -p /misc-toolbar-default -n -t bool -s false
xfconf-query -c xfce4-terminal -p /title-mode -n -t string -s "TERMINAL_TITLE_HIDE"
xfconf-query -c xfce4-terminal -p /color-foreground -n -t string -s "#d2d25050ffff"
xfconf-query -c xfce4-terminal -p /color-background -n -t string -s "#0b840068da7"
xfconf-query -c xfce4-terminal -p /tab-activity-color -n -t string -s "1c1c7171d8d8"

# Import remaining conf files
sudo cp -f ~/arch-install-scripts/configs/xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/
sudo cp -f ~/arch-install-scripts/configs/startup/* /etc/xdg/autostart/

# sudo rm -r ~/arch-install-scripts
