#!/bin/bash

sudo dnf install gnome-tweak-tool arc-theme -y
gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
curl --proxy http://127.0.0.1:8082 https://brave-browser-rpm-release.s3.brave.com/brave-core.asc > brave-core.asc
sudo rpm --import brave-core.asc
rm -rf brave-core.asc
echo "gpgcheck=1" >> /etc/yum.repos.d/brave-browser-rpm-release.s3.brave.com_x86_64_.repo
sudo dnf remove firefox -y
