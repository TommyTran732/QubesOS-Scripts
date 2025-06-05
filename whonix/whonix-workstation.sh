#!/bin/sh

# Copyright (C) 2022-2025 Thien Tran
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

# Run this as root. Whonix workstation stopped allowing the default user to use sudo.

set -eu

unpriv(){
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

# Setting umask to 077
# Whonix defaults to zsh - I need to set it for zsh later.
umask 077
sed -i 's/^UMASK.*/UMASK 077/g' /etc/login.defs
sed -i 's/^HOME_MODE/#HOME_MODE/g' /etc/login.defs
echo 'umask 077' | sudo tee -a /etc/bash.bashrc

# Make home directory private
chmod 700 /home/*

# Avoid phased updates
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/apt/apt.conf.d/99sane-upgrades /etc/apt/apt.conf.d/99sane-upgrades
chmod 644 /etc/apt/apt.conf.d/99sane-upgrades

# Install packages
apt-get install --no-install-recommends arc-theme pipewire-pulse qt5-style-plugins -y

# Restrict /proc and access
systemctl enable --now proc-hidepid.service

# Reduce kernel information leaks
# Will break a lot of applications. The apps I use on Whonix work fine with it so I am enabling it.
systemctl enable --now hide-hardware-info.service

# Flatpak update service
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.service /etc/systemd/user/update-user-flatpaks.service
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.timer /etc/systemd/user/update-user-flatpaks.timer

# Theming
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/environment /etc/environment

sudo mkdir -p /etc/gtk-3.0
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-3.0/settings.ini /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-4.0/settings.ini /etc/gtk-4.0/settings.ini
