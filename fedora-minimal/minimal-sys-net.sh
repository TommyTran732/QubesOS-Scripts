#!/bin/bash

sudo dnf install -y qubes-core-agent-networking qubes-core-agent-network-manager NetworkManager-wifi network-manager-applet wireless-tools notification-daemon gnome-keyring polkit @hardware-support arc-theme

sudo mkdir /etc/gtk-3.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini
