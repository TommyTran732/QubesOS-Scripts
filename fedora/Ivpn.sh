#!/bin/bash

sudo dnf config-manager --add-repo https://repo.ivpn.net/stable/fedora/generic/ivpn.repo
sudo dnf install ivpn-ui

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'

[org/gnome/desktop/media-handling]
automount=false
automount-open=false" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

sudo rm -rf /usr/share/icons/Arc

sudo mkdir -p /etc/qubes-bind-dirs.d
sudo tee /etc/qubes-bind-dirs.d/50_user.conf << EOF > /dev/null
binds+=( '/opt/ivpn/mutable' )
EOF

#Run these in the AppVM:
#echo "sleep 10 # Waiting a bit so that IVPN can establish connection
#/usr/lib/qubes/qubes-setup-dnat-to-ns" | sudo tee -a /rw/config/rc.local
