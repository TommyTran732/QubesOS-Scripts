#!/bin/bash

# Copyright (C) 2023-2024 Thien Tran
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

set -eu -o pipefail

# Enabling discard and fstrim
sudo sed -i 's/issue_discards = 0/issue_discards = 1/' /etc/lvm/lvm.conf
sudo systemctl enable --now fstrim.timer

sudo qubes-dom0-update anti-evil-maid qubes-ctap-dom0 qt5ct qt5-qtstyleplugins

# Configure PCRs
sudo sed -i 's/ --pcr 19//' /etc/anti-evil-maid.conf
sudo sed -i 's/="/="--pcr 0 --pcr 1 --pcr 2 --pcr 3 --pcr 4 --pcr 10 /' /etc/anti-evil-maid.conf

# Configure sudo prompt for domUs
echo "/usr/bin/echo 1" | sudo tee /etc/qubes-rpc/qubes.VMAuth
echo "@anyvm dom0 ask,default_target=dom0" | sudo tee /etc/qubes-rpc/policy/qubes.VMAuth
sudo chmod +x /etc/qubes-rpc/qubes.VMAuth

# Fix s0ix suspension
# Run this depending on your hardware
# sudo qvm-features dom0 suspend-s0ix 1

# Set qvm-features
# Run these after you have installed the fedora-40 and debian-12 templates

# sudo qvm-features fedora-40 default-menu-items 'org.gnome.Nautilus.desktop org.gnome.Ptyxis.desktop'
# sudo qvm-features fedora-40 netvm-menu-items 'org.gnome.Ptyxis.desktop'

# sudo qvm-features debian-12 default-menu-items 'org.gnome.Console.desktop org.gnome.Nautilus.desktop'
# sudo qvm-features debian-12 netvm-menu-items 'org.gnome.Console.desktop'

# Theming

echo 'QT_QPA_PLATFORMTHEME=gtk2' | sudo tee -a /etc/environment

# Add extra gtk theming - this is probably not necessary, but why not

sudo mkdir -p /etc/gtk-3.0
echo '[Settings]
gtk-theme-name = Arc-Dark
gtk-application-prefer-dark-theme = true' | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
echo '[Settings]
gtk-theme-name = Arc-Dark
gtk-application-prefer-dark-theme = true' | sudo tee /etc/gtk-4.0/settings.ini

# After a reboot, run qt5ct and set the theme to gtk-2
