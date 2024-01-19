#!/bin/bash

# Copyright (C) 2023 Thien Tran
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

#Adding KickSecure's signing key
curl --proxy http://127.0.0.1:8082/ --tlsv1.3 --proto =https --max-time 180 --output ~/derivative.asc https://www.kicksecure.com/derivative.asc
sudo cp ~/derivative.asc /usr/share/keyrings/derivative.asc
echo "deb [signed-by=/usr/share/keyrings/derivative.asc] https://deb.kicksecure.com bullseye main contrib non-free" | sudo tee /etc/apt/sources.list.d/derivative.list
sudo apt update

#Debloat
sudo apt purge -y thunderbird emacs emacs-gtk emacs-bin-common emacs-common firefox* keepassxc cups* system-config-printer* xsettingsd yelp*
sudo apt autoremove -y
sudo apt autoclean

#Distribution morphing
sudo apt install --no-install-recommends kicksecure-qubes-cli gnome-settings-daemon -y
sudo apt autoremove -y
sudo mv /etc/apt/sources.list ~/
sudo touch /etc/apt/sources.list

#Enabling SUID Disabler and Permission Hardener
sudo systemctl enable --now permission-hardening

#Enable hardened malloc
echo "/usr/lib/libhardened_malloc.so/libhardened_malloc.so" | sudo tee /etc/ld.so.preload

#Restrict /proc and access
sudo systemctl enable --now proc-hidepid.service

#Reduce kernel information leaks
#Will break a lot of applications. The apps I use on KickSecure work fine with it so I am enabling it.
sudo systemctl enable --now hide-hardware-info.service

#Install packages
sudo apt install --no-install-recommends tirdad qubes-gpg-split qubes-u2f eog qt5ct qt5-style-plugins arc-theme -y

#Setup SSH client
echo "GSSAPIAuthentication no" | sudo tee /etc/ssh/ssh_config.d/10-custom.conf
echo "VerifyHostKeyDNS yes" | sudo tee -a /etc/ssh/ssh_config.d/10-custom.conf

#Force DNSSEC
sudo sed -i 's/#DNSSEC=no/DNSSEC=yes/g' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

#Theming

echo "export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'

[org/gnome/desktop/media-handling]
automount=false
automount-open=false" | sudo tee /etc/dconf/db/local.d/custom

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