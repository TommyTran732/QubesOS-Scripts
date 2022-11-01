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

#Obviously replace vault with the actual GPG backend that you are using https://www.qubes-os.org/doc/split-gpg/
echo "emails  vault allow" | sudo tee /etc/qubes-rpc/policy/qubes.Gpg
echo "@anyvm  @anyvm  ask,default_target=vault" | sudo tee -a /etc/qubes-rpc/policy/qubes.Gpg

#Same thing, but for split SSH. No default allow here because here though because there will not be a timeout or anything like that. 
echo "@anyvm  @anyvm ask,default_target=vault" | sudo tee /etc/qubes-rpc/policy/qubes.SshAgent

#Enabling VMAuth - if you want to get the prompt you will still need to configure the guest VMs tho
echo "/usr/bin/echo 1" | sudo tee /etc/qubes-rpc/qubes.VMAuth
sudo chmod u+x /etc/qubes-rpc/qubes.VMAuth
echo "@anyvm dom0 ask,default_target=dom0" | sudo tee /etc/qubes-rpc/policy/qubes.VMAuth

#Enabling discard and fstrim
sudo sed -i 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
sudo systemctl enable fstrim.timer
