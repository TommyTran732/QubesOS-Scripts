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
sudo systemctl mask debug-shell.service
sudo systemctl mask kdump.service

# Setting umask to 077
sudo sed -i 's/^UMASK.*/UMASK 077/g' /etc/login.defs
sudo sed -i 's/^HOME_MODE/#HOME_MODE/g' /etc/login.defs
sudo sed -i 's/umask 022/umask 077/g' /etc/bashrc

# Make home directory private
sudo chmod 700 /home/*

# Harden SSH
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/ssh/ssh_config.d/10-custom.conf /etc/ssh/ssh_config.d/10-custom.conf

# Security kernel settings
download https://raw.githubusercontent.com/secureblue/secureblue/live/files/system/etc/modprobe.d/blacklist.conf /etc/modprobe.d/workstation-blacklist.conf
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/sysctl.d/99-workstation.conf /etc/sysctl.d/99-workstation.conf
# Dracut doesn't seem to work - need to investigate
# dracut -f
sudo sysctl -p

# Disable coredump
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/security/limits.d/30-disable-coredump.conf /etc/security/limits.d/30-disable-coredump.conf
sudo mkdir -p /etc/systemd/coredump.conf.d
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/systemd/coredump.conf.d/disable.conf /etc/systemd/coredump.conf.d/disable.conf

# Setup dconf
sudo mkdir -p /etc/dconf/db/local.d/locks

download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/locks/automount-disable /etc/dconf/db/local.d/locks/automount-disable
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/locks/privacy /etc/dconf/db/local.d/locks/privacy

download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/adw-gtk3-dark /etc/dconf/db/local.d/adw-gtk3-dark
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/automount-disable /etc/dconf/db/local.d/automount-disable
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/prefer-dark /etc/dconf/db/local.d/prefer-dark
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dconf/db/local.d/privacy /etc/dconf/db/local.d/privacy

sudo dconf update

# Fix portals
sudo mkdir -p /etc/xdg-desktop-portal
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/xdg-desktop-portal/portals.conf /etc/xdg-desktop-portal/portals.conf

# Setup ZRAM
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf

# Flatpak update service
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.service /etc/systemd/user/update-user-flatpaks.service
download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.timer /etc/systemd/user/update-user-flatpaks.timer

# Setup networking
# We don't need the usual mac address randomization and stuff here, because this template is not used for sys-net

sudo mkdir -p /etc/systemd/system/NetworkManager.service.d
download https://gitlab.com/divested/brace/-/raw/master/brace/usr/lib/systemd/system/NetworkManager.service.d/99-brace.conf /etc/systemd/system/NetworkManager.service.d/99-brace.conf
sudo sed -i 's@ReadOnlyPaths=/etc/NetworkManager@#ReadOnlyPaths=/etc/NetworkManager@' /etc/systemd/system/NetworkManager.service.d/99-brace.conf
sudo sed -i 's@ReadWritePaths=-/etc/NetworkManager/system-connections@#ReadWritePaths=-/etc/NetworkManager/system-connections@' /etc/systemd/system/NetworkManager.service.d/99-brace.conf

# Disable GJS and WebkitGTK JIT
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/environment /etc/environment

# Fix GNOME environment variable
echo '
XDG_CURRENT_DESKTOP=GNOME' | sudo tee -a /etc/environment

# Moving DNF handling to the bottom as the Qubes template just breaks when repos are changed and needs a reboot to fix

# Remove unwanted groups
sudo dnf -y group remove 'Container Management' 'Desktop accessibility' 'Firefox Web Browser' 'Guest Desktop Agents' 'LibreOffice' 'Printing Support'

# Remove unnecessary stuff from the Qubes template
sudo dnf -y remove gnome-software gnome-system-monitor amd-ucode-firmware '*gpu*' httpd keepassxc thunderbird

# Remove unnecessary stuff from the Fedora-41 template (will be split into whats in the qubes template and whats upstream later)
sudo dnf -y remove c-ares hiredis

# Remove firefox packages
sudo dnf -y remove fedora-bookmarks fedora-chromium-config firefox mozilla-filesystem

# Remove Network + hardware tools packages
sudo dnf -y remove avahi cifs* '*cups' dmidecode dnsmasq geolite2* mtr net-snmp-libs net-tools nfs-utils nmap-ncat nmap-ncat opensc openssh-server rsync rygel sgpio tcpdump teamd traceroute usb_modeswitch

# Remove support for some languages and spelling
sudo dnf -y remove '*anthy*' '*hangul*' ibus-typing-booster '*m17n*' '*pinyin*' '*speech*' texlive-libs words '*zhuyin*'

# Remove codec + image + printers
sudo dnf -y remove openh264 ImageMagick* sane* simple-scan

# Remove Active Directory + Sysadmin + reporting tools
sudo dnf -y remove 'sssd*' realmd cyrus-sasl-gssapi quota* dos2unix kpartx sos samba-client gvfs-smb

# Remove NetworkManager
sudo dnf -y remove NetworkManager-pptp-gnome NetworkManager-ssh-gnome NetworkManager-openconnect-gnome NetworkManager-openvpn-gnome NetworkManager-vpnc-gnome ppp* ModemManager

# Remove Gnome apps
sudo dnf remove -y baobab chrome-gnome-shell eog gnome-boxes gnome-calculator gnome-calendar gnome-characters gnome-classic* gnome-clocks gnome-color-manager gnome-connections \
    gnome-contacts gnome-disk-utility gnome-font-viewer gnome-logs gnome-maps gnome-photos gnome-remote-desktop gnome-screenshot gnome-shell-extension-apps-menu \
    gnome-shell-extension-background-logo gnome-shell-extension-launch-new-instance gnome-shell-extension-places-menu gnome-shell-extension-window-list gnome-text-editor \
    gnome-themes-extra gnome-tour gnome-user* gnome-weather loupe snapshot totem

# Remove apps
sudo dnf remove -y abrt* cheese evince file-roller* libreoffice* mediawriter rhythmbox yelp

# Remove other packages
sudo dnf remove -y lvm2 rng-tools thermald '*perl*'

# Disable openh264 repo
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=0

# Install custom packages
sudo dnf -y install qubes-ctap qubes-gpg-split adw-gtk3-theme flatpak ncurses xdg-desktop-portal-gtk

# Setup hardened_malloc
sudo https_proxy=127.0.0.1:8082 dnf copr enable secureblue/hardened_malloc -y
sudo dnf install -y hardened_malloc
echo 'libhardened_malloc.so' | sudo tee /etc/ld.so.preload
sudo chmod 644 /etc/ld.so.preload

# Enable hardened_malloc for Flatpak
sudo flatpak override --system --filesystem=host-os:ro --env=LD_PRELOAD=/var/run/host/usr/lib64/libhardened_malloc.so

## Unforunately, user override needs to be run per-app VM
flatpak override --user --filesystem=host-os:ro --env=LD_PRELOAD=/var/run/host/usr/lib64/libhardened_malloc.so

# Setup DNF
download https://raw.githubusercontent.com/Metropolis-Nexus/Common-Files/main/etc/dnf/dnf.conf /etc/dnf/dnf.conf
sudo sed -i 's/^metalink=.*/&\&protocol=https/g' /etc/yum.repos.d/*
