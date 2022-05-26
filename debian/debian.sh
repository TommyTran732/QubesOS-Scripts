#!/bin/bash

sudo apt purge -y thunderbird emacs emacs-gtk emacs-bin-common emacs-common firefox* keepassxc cups* vim* system-config-printer* xsettingsd xterm* yelp*
sudo apt autoremove -y
sudo apt autoclean
sudo apt install -y eog qt5ct qt5-style-plugins arc-theme

git config --global http.proxy http://127.0.0.1:8082
git clone https://github.com/horst3180/arc-icon-theme
mv arc-icon-theme/Arc /usr/share/icons
rm -rf arc-icon-theme

echo "export export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

sudo mkdir /etc/gtk-3.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir /etc/gtk-4.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-4.0/settings.ini

sudo cat > /etc/dconf/db/local.d/custom <<- 'EOF'
[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'
icon-theme='Arc'
EOF
