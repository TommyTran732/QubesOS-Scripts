#!/bin/bash

sudo dnf remove thunderbird gnome-remote-desktop gnome-calendar gnome-calculator gnome-weather gnome-contacts gnome-clock gnome-maps gnome-screenshot gnome-logs gnome-character gnome-font-viewer gnome-color-manager simple-scan keepassxc geditcheese firefox baobab yelp -y
sudo dnf autoremove -y
sudo dnf install arc-theme -y
gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
curl --proxy http://127.0.0.1:8082 https://brave-browser-rpm-release.s3.brave.com/brave-core.asc > brave-core.asc
sudo rpm --import brave-core.asc
rm -rf brave-core.asc
echo "gpgcheck=1" >> /etc/yum.repos.d/brave-browser-rpm-release.s3.brave.com_x86_64_.repo
sudo dnf intall brave-browser -y
