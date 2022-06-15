#!/bin/bash

sudo apt install -y qubes-core-agent-networking qubes-core-agent-network-manager network-manager-applet firmware-iwlwifi gnome-keyring arc-theme

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
