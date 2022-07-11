#!/bin/bash

#Enabling SUID Disabler and Permission Hardener
sudo systemctl enable --now permission-hardening

#Install pages
sudo apt install --no-install-recommends linux-headers-amd64 lkrg-dkms qt5ct qt5-style-plugins arc-theme element-desktop git -y

#Enable hardened malloc
echo "/usr/lib/libhardened_malloc.so/libhardened_malloc.so" | sudo tee /etc/ld.so.preload

#Restrict /proc and access
sudo systemctl enable --now proc-hidepid.service

#Reduce kernel information leaks
#Will break a lot of applications. The apps I use on Whonix work fine with it so I am enabling it.
sudo systemctl enable --now hide-hardware-info.service

echo "export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

sudo mkdir -p /etc/gtk-3.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-4.0/settings.ini
