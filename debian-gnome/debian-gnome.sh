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


# Compliance
run0 systemctl mask debug-shell.service

# Setting umask to 077
# Kicksecure defaults to zsh - I need to set it for zsh later.
umask 077
run0 sed -i 's/^UMASK.*/UMASK 077/g' /etc/login.defs
run0 sed -i 's/^HOME_MODE/#HOME_MODE/g' /etc/login.defs
echo 'umask 077' | run0 tee -a /etc/bash.bashrc

# Make home directory private
run0 chmod 700 /home/*

# Harden SSH
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/ssh/ssh_config.d/10-custom.conf /etc/ssh/ssh_config.d/10-custom.conf
run0 chmod 644 /etc/ssh/ssh_config.d/10-custom.conf

# Disable coredump
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/security/limits.d/30-disable-coredump.conf /etc/security/limits.d/30-disable-coredump.conf

# Setup dconf
umask 022
run0 mkdir -p /etc/dconf/db/local.d/locks

download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/locks/automount-disable /etc/dconf/db/local.d/locks/automount-disable
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/locks/privacy /etc/dconf/db/local.d/locks/privacy

download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/automount-disable /etc/dconf/db/local.d/automount-disable
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/prefer-dark /etc/dconf/db/local.d/prefer-dark
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/privacy /etc/dconf/db/local.d/privacy

run0 dconf update
umask 077

# Fix portals
run0 mkdir -p /etc/xdg-desktop-portal
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/xdg-desktop-portal/portals.conf /etc/xdg-desktop-portal/portals.conf

# Avoid phased updates
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/apt/apt.conf.d/99sane-upgrades /etc/apt/apt.conf.d/99sane-upgrades
run0 chmod 644 /etc/apt/apt.conf.d/99sane-upgrades


run0 apt-get update -y
run0 apt-get full-upgrade -y
run0 apt-get autoremove -y

# Debloat

# Remove unnecessary stuff from the Qubes template
run0 apt-get purge -y gnome-software gnome-system-monitor thunderbird keepassxc

# Remove Network + hardware tools packages
run0 apt-get purge -y avahi* cups* '*nfs*' rygel '*smtp*' system-config-printer* '*telnet*'

# Remove support for some languages and spelling
run0 apt-get purge -y '*speech*'

# Remove codec + image + printers
run0 apt-get purge -y ImageMagick* sane* simple-scan

# Remove Active Directory + Sysadmin + reporting tools
run0 apt-get purge -y realmd

# Remove unnecessary network tools
run0 apt-get purge -y ifupdown mobile-broadband-provider-info modemmanager

# Remove Gnome apps
run0 apt-get purge -y baobab chrome-gnome-shell eog gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager \
    gnome-contacts gnome-disk-utility gnome-font-viewer gnome-logs gnome-maps gnome-music gnome-remote-desktop gnome-shell-extensions \
    gnome-sound-recorder gnome-tweaks gnome-user-share gnome-weather totem

# Remove apps
run0 apt-get purge -y cheese evince evolution file-roller* firefox* libreoffice* seahorse shotwell synaptic* rhythmbox yelp

# Remove other packages
run0 apt-get purge -y cron lvm2 lynx '*vmware*' xserver-xephyr xsettingsd sudo su runuser

run0 apt-get autoremove -y
run0 apt-get autoclean

# Add console group
run0 groupadd --system console
run0 usermod -aG console user

# Add extrepo
run0 apt-get install -y extrepo

# Adding KickSecure's repo
run0 http_proxy=http://127.0.0.1:8082 https_proxy=http://127.0.0.1:8082 extrepo enable kicksecure

# Distribution morphing
run0 apt-get update
run0 apt-get full-upgrade -y
run0 apt-get install --no-install-recommends kicksecure-qubes-cli -y
run0 apt-get autoremove -y
run0 repository-dist --enable --repository stable-proposed-updates
run0 extrepo disable kicksecure
run0 mv /etc/apt/sources.list ~/
run0 touch /etc/apt/sources.list


# Restrict /proc and access
run0 systemctl enable --now proc-hidepid.service

# Reduce kernel information leaks
# Will break a lot of applications. The apps I use on KickSecure work fine with it so I am enabling it.
run0 systemctl enable --now hide-hardware-info.service

# Install packages
run0 apt-get update
run0 apt-get install --no-install-recommends gnome-console flatpak qubes-ctap qubes-gpg-split -y

# Flatpak update service
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.service /etc/systemd/user/update-user-flatpaks.service
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.timer /etc/systemd/user/update-user-flatpaks.timer
