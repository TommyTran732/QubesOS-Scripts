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
run0 sed -i 's/issue_discards = 0/issue_discards = 1/' /etc/lvm/lvm.conf
run0 systemctl enable --now fstrim.timer

run0 qubes-dom0-update anti-evil-maid qubes-ctap-dom0 qubes-video-companion-dom0 qt5-qtstyleplugins

# Configure PCRs
run0 sed -i 's/ --pcr 19//' /etc/anti-evil-maid.conf
run0 sed -i 's/="/="--pcr 0 --pcr 1 --pcr 2 --pcr 3 --pcr 4 /' /etc/anti-evil-maid.conf

# Configure run0 prompt for domUs
echo "/usr/bin/echo '1'" | run0 tee /etc/qubes-rpc/qubes.VMAuth
echo "@anyvm dom0 ask,default_target=dom0" | run0 tee /etc/qubes-rpc/policy/qubes.VMAuth
run0 chmod +x /etc/qubes-rpc/qubes.VMAuth

# Theming

echo 'QT_QPA_PLATFORMTHEME=gtk2' | run0 tee -a /etc/environment

# Add extra gtk theming - this is probably not necessary, but why not

run0 mkdir -p /etc/gtk-3.0
echo '[Settings]
gtk-theme-name = Arc-Dark
gtk-application-prefer-dark-theme = true' | run0 tee /etc/gtk-3.0/settings.ini

run0 mkdir -p /etc/gtk-4.0
echo '[Settings]
gtk-theme-name = Arc-Dark
gtk-application-prefer-dark-theme = true' | run0 tee /etc/gtk-4.0/settings.ini
