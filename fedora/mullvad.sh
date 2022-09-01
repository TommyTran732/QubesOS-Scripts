#!/bin/bash
#Needs to be installed in a standalone VM for now.

sudo dnf install -y https://mullvad.net/media/app/MullvadVPN-2022.4_x86_64.rpm

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'

[org/gnome/desktop/media-handling]
automount=false
automount-open=false" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

sudo rm -rf /usr/share/icons/Arc

echo "/usr/lib/qubes/qubes-setup-dnat-to-ns" | sudo tee -a /rw/config/rc.local

#I am still missing something here to make it work in a TemplateVM->AppVM setup... not sure what right now.
#sudo mkdir -p /etc/qubes-bind-dirs.d
#sudo tee /etc/qubes-bind-dirs.d50_user.conf << EOF > /dev/null
#binds+=( '/etc/mullvad-vpn' )
#EOF
