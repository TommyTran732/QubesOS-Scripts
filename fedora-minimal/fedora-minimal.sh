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
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

# Compliance
systemctl mask debug-shell.service
systemctl mask kdump.service

# Setting umask to 077
umask 077
sudo sed -i 's/^UMASK.*/UMASK 077/g' /etc/login.defs
sudo sed -i 's/^HOME_MODE/#HOME_MODE/g' /etc/login.defs
sudo sed -i 's/umask 022/umask 077/g' /etc/bashrc

# Make home directory private
sudo chmod 700 /home/*

# Disable timesyncd
systemctl disable --now systemd-timesyncd
systemctl mask systemd-timesyncd

# Harden SSH
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/ssh/ssh_config.d/10-custom.conf /etc/ssh/ssh_config.d/10-custom.conf
chmod 644 /etc/ssh/ssh_config.d/10-custom.conf

# Security kernel settings
download https://raw.githubusercontent.com/secureblue/secureblue/live/files/system/usr/lib/modprobe.d/secureblue-framebuffer.conf /etc/modprobe.d/framebuffer-blacklist.conf
sudo chmod 644 /etc/modprobe.d/framebuffer-blacklist.conf
download https://raw.githubusercontent.com/secureblue/secureblue/live/files/system/usr/lib/modprobe.d/secureblue.conf /etc/modprobe.d/workstation-blacklist.conf
sudo chmod 644 /etc/modprobe.d/workstation-blacklist.conf
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/sysctl.d/99-workstation.conf /etc/sysctl.d/99-workstation.conf
# Dracut doesn't seem to work - need to investigate
# dracut -f
# sudo sysctl -p

# Setup ZRAM
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf

# Install necessary packages
sudo dnf install -y qubes-core-agent-selinux

# Setup hardened_malloc
sudo https_proxy=https://127.0.0.1:8082 dnf copr enable secureblue/hardened_malloc -y
sudo dnf install -y hardened_malloc
echo 'libhardened_malloc.so' | sudo tee /etc/ld.so.preload
sudo chmod 644 /etc/ld.so.preload

# Prepare for SELinux
sudo touch /.autorelabel
