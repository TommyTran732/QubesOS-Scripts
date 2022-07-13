#!/bin/bash

sudo dnf install -y qubes-core-agent-networking qubes-core-agent-network-manager NetworkManager-wifi network-manager-applet notification-daemon gnome-keyring @hardware-support chrony arc-theme

sudo systemctl disable --now systemd-timesyncd
sudo curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /etc/chrony/chrony.conf
sudo systemctl enable --now chronyd

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
