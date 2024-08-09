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
    sudo -u nobody "$@"
}

# Compliance
sudo systemctl mask debug-shell.service
sudo systemctl mask kdump.service

# Setting umask to 077
umask 077
sudo sed -i 's/^UMASK.*/UMASK 077/g' /etc/login.defs
sudo sed -i 's/^HOME_MODE/#HOME_MODE/g' /etc/login.defs
sudo sed -i 's/umask 022/umask 077/g' /etc/bashrc

# Make home directory private
sudo chmod 700 /home/*

# Harden SSH
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/ssh/ssh_config.d/10-custom.conf | sudo tee /etc/ssh/ssh_config.d/10-custom.conf > /dev/null
sudo chmod 644 /etc/ssh/ssh_config.d/10-custom.conf

# Security kernel settings
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/secureblue/secureblue/live/files/system/etc/modprobe.d/blacklist.conf | sudo tee /etc/modprobe.d/workstation-blacklist.conf > /dev/null
sudo chmod 644 /etc/modprobe.d/workstation-blacklist.conf
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/sysctl.d/99-workstation.conf | sudo tee /etc/sysctl.d/99-workstation.conf > /dev/null
sudo chmod 644 /etc/sysctl.d/99-workstation.conf
# Dracut doesn't seem to work - need to investigate
# dracut -f
sudo sysctl -p

# Disable coredump
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/security/limits.d/30-disable-coredump.conf | sudo tee /etc/security/limits.d/30-disable-coredump.conf > /dev/null
sudo chmod 644 /etc/security/limits.d/30-disable-coredump.conf
sudo mkdir -p /etc/systemd/coredump.conf.d
sudo chmod 755 /etc/systemd/coredump.conf.d
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/systemd/coredump.conf.d/disable.conf | sudo tee /etc/systemd/coredump.conf.d/disable.conf > /dev/null
sudo chmod 644 /etc/systemd/coredump.conf.d/disable.conf

# Setup dconf
umask 022
mkdir -p /etc/dconf/db/local.d/locks

unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/locks/automount-disable | sudo tee /etc/dconf/db/local.d/locks/automount-disable > /dev/null
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/locks/privacy | sudo tee /etc/dconf/db/local.d/locks/privacy > /dev/null

unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/adw-gtk3-dark | sudo tee /etc/dconf/db/local.d/adw-gtk3-dark > /dev/null
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/automount-disable | sudo tee /etc/dconf/db/local.d/automount-disable > /dev/null
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/prefer-dark | sudo tee /etc/dconf/db/local.d/prefer-dark > /dev/null
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/privacy | sudo tee /etc/dconf/db/local.d/privacy > /dev/null

sudo dconf update
umask 077

# Setup ZRAM
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/systemd/zram-generator.conf | sudo tee /etc/systemd/zram-generator.conf > /dev/null

# Flatpak update service
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.service | sudo tee /etc/systemd/user/update-user-flatpaks.service > /dev/null
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.timer | sudo tee /etc/systemd/user/update-user-flatpaks.timer > /dev/null

# Setup networking
# We don't need the usual mac address randomization and stuff here, because this template is not used for sys-net

# This breaks saving network settings with the Fedora 40 template rn, so I am commenting it out.
#sudo mkdir -p /etc/systemd/system/NetworkManager.service.d
#unpriv curl --proxy http://127.0.0.1:8082 https://gitlab.com/divested/brace/-/raw/master/brace/usr/lib/systemd/system/NetworkManager.service.d/99-brace.conf | sudo tee /etc/systemd/system/NetworkManager.service.d/99-brace.conf

# Fix GNOME environment variable
echo 'XDG_CURRENT_DESKTOP=GNOME' | sudo tee -a /etc/environment

# Moving DNF handling to the bottom as the Qubes template just breaks when repos are changed and needs a reboot to fix

# Mark packages as manualy installed to avoid removal
sudo dnf mark install flatpak gnome-menus qubes-menus

# Remove unwanted groups
sudo dnf -y group remove 'Container Management' 'Desktop accessibility' 'Firefox Web Browser' 'Guest Desktop Agents' 'LibreOffice' 'Printing Support'

# Remove unnecessary stuff from the Qubes template
sudo dnf -y remove gnome-software httpd keepassxc thunderbird

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
# We deviate from the script in TommyTran732/Linux-Setup-Scripts here, as removing yajl will break qubes integration.
sudo dnf remove -y lvm2 rng-tools thermald '*perl*'

# Disable openh264 repo
sudo dnf config-manager --set-disabled fedora-cisco-openh264

# Install custom packages
# gnome-shell is needed for theming to work
sudo dnf -y install qubes-ctap qubes-gpg-split adw-gtk3-theme ncurses gnome-console gnome-shell

# Setup hardened_malloc
sudo dnf copr enable secureblue/hardened_malloc -y
sudo dnf install -y hardened_malloc
echo 'libhardened_malloc.so' | sudo tee /etc/ld.so.preload
sudo chmod 644 /etc/ld.so.preload

# Setup DNF
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dnf/dnf.conf | sudo tee /etc/dnf/dnf.conf > /dev/null
sudo sed -i 's/^metalink=.*/&\&protocol=https/g' /etc/yum.repos.d/*
sudo sed -i 's/&protocol=https//g' /etc/yum.repos.d/divested-release.repo
