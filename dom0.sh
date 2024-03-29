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

# Enabling discard and fstrim
sudo sed -i 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
sudo systemctl enable fstrim.timer

# Theming

sudo mkdir -p /etc/gtk-3.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-3.0/settings.ini

sudo qubes-dom0-update qubes-u2f-dom0 qt5ct qt5-qtstyleplugins

echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee /etc/environment
