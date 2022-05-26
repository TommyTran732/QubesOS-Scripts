#!/bin/bash

sudo mkdir -p /etc/gtk-3.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-3.0/settings.ini

sudo qubes-dom0-update qubes-u2f-dom0 qubes-yubikey-dom0 qt5ct qt5-qtstyleplugins
qvm-service --enable personal qubes-u2f-proxy
qvm-service --enable work qubes-u2f-proxy

echo "export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

#Obviously replace vault-gpg with the actual GPG backend that you are using https://www.qubes-os.org/doc/split-gpg/
echo "emails  vault-gpg allow" | sudo tee /etc/qubes-rpc/policy/qubes.Gpg
echo "@anyvm  @anyvm  ask,default_target=vault-gpg" | sudo tee -a /etc/qubes-rpc/policy/qubes.Gpg

#Support for disabling passwordless sudo
echo "/usr/bin/echo 1" >/etc/qubes-rpc/qubes.VMAuth
echo "@anyvm dom0 ask,default_target=dom0" > /etc/qubes-rpc/policy/qubes.VMAuth
