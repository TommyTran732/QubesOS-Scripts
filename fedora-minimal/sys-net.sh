#!/bin/sh

# Copyright (C) 2022-2024 Thien Tran
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

set -eu

unpriv(){
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

# Install necessary packages
sudo dnf install -y @hardware-support arc-theme chrony gnome-keyring fwupd-qubes-vm NetworkManager-wifi network-manager-applet qubes-core-agent-dom0-updates qubes-core-agent-networking qubes-core-agent-network-manager qubes-usb-proxy xfce4-notifyd

# Setup NTS
sudo rm -rf /etc/chrony.conf
download https://raw.githubusercontent.com/Metropolis-nexus/Common-Files/refs/heads/main/etc/chrony.conf /etc/chrony.conf
download https://raw.githubusercontent.com/Metropolis-nexus/Common-Files/refs/heads/main/etc/sysconfig/chronyd /etc/sysconfig/chronyd

# Theming
sudo mkdir -p /etc/gtk-3.0
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-3.0/settings.ini /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-4.0/settings.ini /etc/gtk-4.0/settings.ini

# Networking
download https://raw.githubusercontent.com/Metropolis-nexus/Common-Files/refs/heads/main/etc/NetworkManager/conf.d/00-macrandomize.conf /etc/NetworkManager/conf.d/00-macrandomize.conf
download https://raw.githubusercontent.com/Metropolis-nexus/Common-Files/refs/heads/main/etc/NetworkManager/conf.d/01-transient-hostname.conf /etc/NetworkManager/conf.d/01-transient-hostname.conf
sudo hostnamectl hostname 'localhost'
sudo hostnamectl --transient hostname ''

sudo mkdir -p /etc/systemd/system/NetworkManager.service.d
download https://gitlab.com/divested/brace/-/raw/master/brace/usr/lib/systemd/system/NetworkManager.service.d/99-brace.conf /etc/systemd/system/NetworkManager.service.d/99-brace.conf
sudo sed -i 's@ReadOnlyPaths=/etc/NetworkManager@#ReadOnlyPaths=/etc/NetworkManager@' /etc/systemd/system/NetworkManager.service.d/99-brace.conf
sudo sed -i 's@ReadWritePaths=-/etc/NetworkManager/system-connections@#ReadWritePaths=-/etc/NetworkManager/system-connections@' /etc/systemd/system/NetworkManager.service.d/99-brace.conf
