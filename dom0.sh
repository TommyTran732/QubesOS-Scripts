#!/bin/bash

sudo mkdir /etc/gtk-3.0
echo '
[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini

sudo qubes-dom0-update qubes-u2f-dom0 qubes-yubikey-dom0
qvm-service --enable work qubes-u2f-proxy
