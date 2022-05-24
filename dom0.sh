#!/bin/bash

sudo mkdir /etc/gtk-3.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini

sudo qubes-dom0-update qubes-u2f-dom0 qubes-yubikey-dom0 qt5ct qt5-qtstyleplugins
qvm-service --enable personal qubes-u2f-proxy
qvm-service --enable work qubes-u2f-proxy

echo "export export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

#I am using the sys-usb VM for GPG here because I am using a PGP smartcard. You probably shouldn't do this if you store your GPG private key on disk. It **might** be safer to still have a dedicated gpg-backend VM for this, but then you will have to reassign the smartcard to the VM after every boot, which could be annoying.
echo "emails  sys-usb allow" > /etc/qubes-rpc/policy/qubes.Gpg
echo "@anyvm  @anyvm  ask,default_target=sys-usb" >> /etc/qubes-rpc/policy/qubes.Gpg
