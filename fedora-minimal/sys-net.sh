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

set -e

# Install necessary packages
dnf install -y @hardware-support arc-theme chrony gnome-keyring NetworkManager-wifi network-manager-applet qubes-core-agent-networking qubes-core-agent-network-manager xfce4-notifyd

# Setup NTS
sudo rm -rf /etc/chrony.conf
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf | tee /etc/chrony.conf
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/sysconfig/chronyd | tee /etc/sysconfig/chronyd

# Theming
sudo mkdir -p /etc/gtk-3.0
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-3.0/settings.ini | tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-4.0/settings.ini | tee /etc/gtk-4.0/settings.ini

# Networking
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/NetworkManager/conf.d/00-macrandomize.conf | tee /etc/NetworkManager/conf.d/00-macrandomize.conf
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/NetworkManager/conf.d/01-transient-hostname.conf | tee /etc/NetworkManager/conf.d/01-transient-hostname.conf
sudo hostnamectl hostname 'localhost'
sudo hostnamectl --transient hostname ''

# This breaks saving network settings with the Fedora 40 template rn, so I am commenting it out.
#sudo mkdir -p /etc/systemd/system/NetworkManager.service.d
#curl --proxy http://127.0.0.1:8082 https://gitlab.com/divested/brace/-/raw/master/brace/usr/lib/systemd/system/NetworkManager.service.d/99-brace.conf | tee /etc/systemd/system/NetworkManager.service.d/99-brace.conf
