#!/bin/bash

sudo dnf install -y https://mullvad.net/media/app/MullvadVPN-2022.4_x86_64.rpm
sudo systemctl enable mullvad-daemon

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'

[org/gnome/desktop/media-handling]
automount=false
automount-open=false" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

sudo rm -rf /usr/share/icons/Arc

sudo mkdir -p /etc/qubes-bind-dirs.d
sudo tee /etc/qubes-bind-dirs.d/50_user.conf << EOF > /dev/null
binds+=( '/etc/mullvad-vpn' )
EOF

#Run these in the AppVM:
#echo "sleep 10 # Waiting a bit that Mullvad succeeds to establish connection
#/usr/lib/qubes/qubes-setup-dnat-to-ns" | sudo tee -a /rw/config/rc.local
