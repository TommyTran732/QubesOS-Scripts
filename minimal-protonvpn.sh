#!/bin/bash 


sudo dnf install -y qubes-core-agent-networking qubes-core-agent-network-manager NetworkManager-open network-manager-applet notification-daemon gnome-keyring polkit arc-theme

sudo mkdir /etc/gtk-3.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini

sudo dnf install https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
sudo dnf install protonvpn -y
