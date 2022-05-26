#!/bin/bash

sudo apt purge -y thunderbird emacs firefox* keepassxc cups* vim* system-config-printer* xsettingsd xterm*
sudo apt autoremove
sudo apt install qt5ct qt5-qtstyleplugins arc-theme

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

echo "export export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment
