#!/bin/bash

sudo apt install --no-install-recommends qubes-core-agent-networking qubes-core-agent-network-manager notification-daemon gnome-keyring arc-theme -y

curl --proxy http://127.0.0.1:8082/ -O https://protonvpn.com/download/protonvpn-stable-release_1.0.1-1_all.deb
sudo apt install --no-install-recommends ./protonvpn-stable-release_1.0.1-1_all.deb -y
sudo apt update
sudo apt install --no-install-recommends protonvpn -y

sudo mkdir -p /etc/gtk-3.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-4.0/settings.ini