#!/bin/bash

sudo apt install --no-install-recommends qubes-core-agent-networking qubes-core-agent-network-manager wireless-tools notification-daemon gnome-keyring firmware-iwlwifi arc-theme -y

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