#!/bin/bash

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
sudo sed -i 's/^USERGROUPS_ENAB.*/USERGROUPS_ENAB no/g' /etc/login.defs
sudo sed -i 's/umask 022/umask 077/g' /etc/bashrc

# Make home directory private
sudo chmod 700 /home/*

# Harden SSH
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/ssh/ssh_config.d/10-custom.conf | sudo tee /etc/ssh/ssh_config.d/10-custom.conf
sudo chmod 644 /etc/ssh/ssh_config.d/10-custom.conf

# Security kernel settings
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf | sudo tee /etc/modprobe.d/30_security-misc.conf
sudo chmod 644 /etc/modprobe.d/30_security-misc.conf
sudo sed -i 's/#install msr/install msr/g' /etc/modprobe.d/30_security-misc.conf
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/990-security-misc.conf | sudo tee /etc/sysctl.d/990-security-misc.conf
sudo chmod 644 /etc/sysctl.d/990-security-misc.conf
sudo sed -i 's/kernel\.yama\.ptrace_scope[[:space:]]*=.*/kernel.yama.ptrace_scope=3/g' /etc/sysctl.d/990-security-misc.conf
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_silent-kernel-printk.conf | sudo tee /etc/sysctl.d/30_silent-kernel-printk.conf
sudo chmod 644 /etc/sysctl.d/30_silent-kernel-printk.conf
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_security-misc_kexec-disable.conf | sudo tee /etc/sysctl.d/30_security-misc_kexec-disable.conf
sudo chmod 644 /etc/sysctl.d/30_security-misc_kexec-disable.conf
# Dracut doesn't seem to work - need to investigate
# dracut -f
sudo sysctl -p

# Disable coredump
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/security/limits.d/30-disable-coredump.conf | sudo tee /etc/security/limits.d/30-disable-coredump.conf

# Setup dconf
umask 022
mkdir -p /etc/dconf/db/local.d/locks

unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/locks/automount-disable | sudo tee /etc/dconf/db/local.d/locks/automount-disable
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/locks/privacy | sudo tee /etc/dconf/db/local.d/locks/privacy

unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/adw-gtk3-dark | sudo tee /etc/dconf/db/local.d/adw-gtk3-dark
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/automount-disable | sudo tee /etc/dconf/db/local.d/automount-disable
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/prefer-dark | sudo tee /etc/dconf/db/local.d/prefer-dark
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dconf/db/local.d/privacy | sudo tee /etc/dconf/db/local.d/privacy

sudo dconf update
umask 077

# Setup ZRAM
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/systemd/zram-generator.conf | sudo tee /etc/systemd/zram-generator.conf

# Flatpak update service
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.service | sudo tee /etc/systemd/user/update-user-flatpaks.service
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/user/update-user-flatpaks.timer | sudo tee /etc/systemd/user/update-user-flatpaks.timer

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
sudo dnf -y install 'https://divested.dev/rpm/fedora/divested-release-20231210-2.noarch.rpm'
sudo dnf config-manager --save --setopt=divested.includepkgs=divested-release,real-ucode,microcode_ctl,amd-ucode-firmware,hardened_malloc
sudo sed -i 's/^metalink=.*/&?protocol=https/g' /etc/yum.repos.d/divested-release.repo
sudo dnf -y install hardened_malloc
echo 'libhardened_malloc.so' | sudo tee /etc/ld.so.preload

# Setup DNF
unpriv curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/dnf/dnf.conf | sudo tee /etc/dnf/dnf.conf
sudo sed -i 's/^metalink=.*/&\&protocol=https/g' /etc/yum.repos.d/*
sudo sed -i 's/&protocol=https//g' /etc/yum.repos.d/divested-release.repo