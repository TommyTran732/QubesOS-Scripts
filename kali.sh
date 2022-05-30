#!/bin/bash

#Debloat
sudo apt purge firefox* chromium* thunderbird* emacs emacs-gtk emacs-bin-common emacs-common xsettingsd yelp* -y
sudo apt autoremove -y

#Install packages
sudo apt install --no-install-recommends qubes-gpg-split qubes-u2f eog qt5ct qt5-style-plugins arc-theme goldeneye -y

#Unmark hold
sudo apt-mark unhold libqubes-rpc-filecopy2 libqubesdb pulseaudio-qubes python3-qubesdb python3-qubesimgconverter qubes-core-agent-dom0-updates qubes-core-agent-nautilus qubes-core-agent-network-manager qubes-core-agent-passwordless-root qubes-core-agent qubes-core-qrexec qubes-gpg-split qubes-gui-agent qubes-img-converter qubes-input-proxy-sender qubes-kernel-vm-support qubes-mgmt-salt-vm-connector qubes-pdf-converter qubes-u2f qubes-usb-proxy qubes-utils qubes-vm-dependencies qubes-vm-recommended qubesdb-vm qubesdb xserver-xorg-input-qubes xserver-xorg-qubes-common

#Theming
git config --global http.proxy http://127.0.0.1:8082
git clone https://github.com/horst3180/arc-icon-theme
sudo mv arc-icon-theme/Arc /usr/share/icons
rm -rf arc-icon-theme

echo "export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

sudo mkdir /etc/gtk-3.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Arc" | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir /etc/gtk-4.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Arc" | sudo tee /etc/gtk-4.0/settings.ini