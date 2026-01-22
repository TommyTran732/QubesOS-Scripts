#!/bin/bash

# Copyright (C) 2023-2025 Thien Tran
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

sudo qubes-dom0-update anti-evil-maid qubes-ctap-dom0 qubes-dist-upgrade qubes-video-companion-dom0 qt5-qtstyleplugins

# Remove kernel if kernel-latest is being used
#sudo dnf remove -y kernel kernel-devel kernel-modules kernel-qubes-vm

# Configure PCRs
sudo sed -i 's/ --pcr 19//' /etc/anti-evil-maid.conf
sudo sed -i 's/="/="--pcr 0 --pcr 1 --pcr 2 --pcr 3 --pcr 4 /' /etc/anti-evil-maid.conf

# Configure sudo prompt for domUs
echo "/usr/bin/echo '1'" | sudo tee /etc/qubes-rpc/qubes.VMAuth
echo "@anyvm dom0 ask,default_target=dom0" | sudo tee /etc/qubes-rpc/policy/qubes.VMAuth
sudo chmod +x /etc/qubes-rpc/qubes.VMAuth

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
