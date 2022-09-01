#!/bin/bash

sudo dnf install https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
sudo dnf install protonvpn -y

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'

[org/gnome/desktop/media-handling]
automount=false
automount-open=false" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

sudo rm -rf /usr/share/icons/Arc
