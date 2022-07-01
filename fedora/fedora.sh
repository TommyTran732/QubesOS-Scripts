#!/bin/bash

sudo dnf remove firefox thunderbird totem gnome-remote-desktop gnome-calendar gnome-disk-utility gnome-calculator gnome-connections gnome-weather gnome-contacts gnome-clocks gnome-maps gnome-screenshot gnome-logs gnome-characters gnome-font-viewer gnome-color-manager simple-scan keepassxc cheese baobab yelp evince* httpd mozilla* cups rygel -y
sudo dnf autoremove -y
sudo dnf install qubes-u2f qubes-gpg-split -y
echo "countme=False" | sudo tee -a /etc/dnf/dnf.conf

git config --global http.proxy http://127.0.0.1:8082
git clone https://github.com/horst3180/arc-icon-theme
sudo mv arc-icon-theme/Arc /usr/share/icons
rm -rf arc-icon-theme

echo "[org/gnome/desktop/interface]
color-scheme='prefer-dark'
icon-theme='Arc'" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

#Flatpak update service

echo "[Unit]
Description=Update user Flatpaks

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak --user update -y

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/user/update-user-flatpaks.service

echo "[Unit]
Description=Update user Flatpaks daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target" | sudo tee /etc/systemd/user/update-user-flatpaks.timer
