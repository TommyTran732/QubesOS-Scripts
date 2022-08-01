#!/bin/bash
#This needs to be in a standalone VM

sudo dnf install -y https://mullvad.net/media/app/MullvadVPN-2022.2_x86_64.rpm

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

sudo rm -rf /usr/share/icons/Arc
