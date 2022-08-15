#!/bin/bash

sudo dnf install -y https://mullvad.net/media/app/MullvadVPN-2022.3_x86_64.rpm

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

sudo rm -rf /usr/share/icons/Arc

echo "/usr/lib/qubes/qubes-setup-dnat-to-ns" | sudo tee -a /rw/config/rc.local

sudo mkdir -p /etc/qubes-bind-dirs.d
sudo tee /etc/qubes-bind-dirs.d50_user.conf << EOF > /dev/null
binds+=( '/etc/mullvad-vpn' )
EOF
