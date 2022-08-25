#!/bin/bash

sudo dnf install -y qubes-core-agent-networking qubes-core-agent-network-manager NetworkManager-wifi network-manager-applet notification-daemon gnome-keyring @hardware-support chrony arc-theme

sudo systemctl disable --now systemd-timesyncd
sudo rm -rf /etc/chrony.conf
sudo curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /etc/chrony.conf
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

echo '[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=${CONNECTION}/${BOOT}
' | sudo tee /etc/NetworkManager/conf.d/00-macrandomize.conf
