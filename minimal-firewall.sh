#!/bin/bash

sudo dnf install -y qubes-core-agent-networking iproute qubes-core-agent-dom0-updates arc-theme

sudo mkdir /etc/gtk-3.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini
