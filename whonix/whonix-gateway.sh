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

set -eu

unpriv(){
  run0 -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | run0 tee "${2}" > /dev/null
}

# Setting umask to 077
# Whonix defaults to zsh - I need to set it for zsh later.
umask 077
run0 sed -i 's/^UMASK.*/UMASK 077/g' /etc/login.defs
run0 sed -i 's/^HOME_MODE/#HOME_MODE/g' /etc/login.defs
echo 'umask 077' | run0 tee -a /etc/bash.bashrc

# Make home directory private
run0 chmod 700 /home/*

# Avoid phased updates
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/apt/apt.conf.d/99sane-upgrades /etc/apt/apt.conf.d/99sane-upgrades > /dev/null
run0 chmod 644 /etc/apt/apt.conf.d/99sane-upgrades

# Install packages
run0 apt-get install --no-install-recommends fwupd-qubes-vm qt5-style-plugins arc-theme -y

# Uninstall packages
run0 apt-get purge -y su sudo runuser

# Restrict /proc and access
run0 systemctl enable --now proc-hidepid.service

# Reduce kernel information leaks
# Will break a lot of applications. The apps I use on Whonix work fine with it so I am enabling it.
run0 systemctl enable --now hide-hardware-info.service

# Enforce connection padding
echo 'ConnectionPadding 1' | run0 tee /usr/local/etc/torrc.d/50_user.conf

# Theming
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/environment /etc/environment

run0 mkdir -p /etc/gtk-3.0
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-3.0/settings.ini /etc/gtk-3.0/settings.ini

run0 mkdir -p /etc/gtk-4.0
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/gtk-4.0/settings.ini /etc/gtk-4.0/settings.ini
