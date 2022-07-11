#!/bin/bash

#Install pages
sudo apt install --no-install-recommends linux-headers-amd64 lkrg-dkms qt5ct qt5-style-plugins arc-theme git -y

#Enabling SUID Disabler and Permission Hardener
sudo systemctl enable --now permission-hardening

#Enable hardened malloc
echo "/usr/lib/libhardened_malloc.so/libhardened_malloc.so" | sudo tee /etc/ld.so.preload

#Restrict /proc and access
sudo systemctl enable --now proc-hidepid.service

#Reduce kernel information leaks
#Will break a lot of applications. The apps I use on Whonix work fine with it so I am enabling it.
sudo systemctl enable --now hide-hardware-info.service

#Theming
git config --global http.proxy http://127.0.0.1:8082
git clone https://github.com/horst3180/arc-icon-theme
sudo mv arc-icon-theme/Arc /usr/share/icons
rm -rf arc-icon-theme

echo "export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

sudo mkdir -p /etc/gtk-3.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Arc" | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Arc" | sudo tee /etc/gtk-4.0/settings.ini
