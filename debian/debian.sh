#!/bin/bash

sudo apt purge -y thunderbird emacs emacs-gtk emacs-bin-common emacs-common firefox* keepassxc cups* vim* system-config-printer* xsettingsd xterm* yelp*
sudo apt autoremove -y
sudo apt autoclean
sudo apt install -y qt5ct qt5-qtstyleplugins arc-theme

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
