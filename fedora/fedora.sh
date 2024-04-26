#!/bin/bash

# Remove unnecessary stuff from the Qubes template
sudo dnf -y thunderbird httpd keepassxc rygel

# Remove firefox packages
sudo dnf -y remove fedora-bookmarks fedora-chromium-config firefox mozilla-filesystem

# Remove Network + hardware tools packages
sudo dnf -y remove '*cups' nmap-ncat nfs-utils nmap-ncat openssh-server net-snmp-libs net-tools opensc traceroute rsync tcpdump teamd geolite2* mtr dmidecode sgpio

# Remove support for some languages and spelling
sudo dnf -y remove ibus-typing-booster '*speech*' '*zhuyin*' '*pinyin*' '*kkc*' '*m17n*' '*hangul*' '*anthy*' words

# Remove codec + image + printers
sudo dnf -y remove openh264 ImageMagick* sane* simple-scan

# Remove Active Directory + Sysadmin + reporting tools
sudo dnf -y remove 'sssd*' realmd adcli cyrus-sasl-plain cyrus-sasl-gssapi mlocate quota* dos2unix kpartx sos abrt samba-client gvfs-smb

# Remove vm and virtual stuff
sudo dnf -y remove 'podman*' '*libvirt*' 'open-vm*' qemu-guest-agent 'hyperv*' spice-vdagent virtualbox-guest-additions vino xorg-x11-drv-vmware xorg-x11-drv-amdgpu
sudo dnf autoremove -y

# Remove NetworkManager
sudo dnf -y remove NetworkManager-pptp-gnome NetworkManager-ssh-gnome NetworkManager-openconnect-gnome NetworkManager-openvpn-gnome NetworkManager-vpnc-gnome ppp* ModemManager

# Remove Gnome apps
sudo dnf remove -y gnome-photos gnome-connections gnome-tour gnome-themes-extra gnome-screenshot gnome-remote-desktop gnome-font-viewer gnome-calculator gnome-calendar gnome-contacts \
    gnome-maps gnome-weather gnome-logs gnome-boxes gnome-disk-utility gnome-clocks gnome-color-manager gnome-characters baobab totem \
    gnome-shell-extension-background-logo gnome-shell-extension-apps-menu gnome-shell-extension-launch-new-instance gnome-shell-extension-places-menu gnome-shell-extension-window-list \
    gnome-classic* gnome-user* gnome-text-editor chrome-gnome-shell eog

# Remove apps
sudo dnf remove -y rhythmbox yelp evince libreoffice* cheese file-roller* mediawriter

# Remove other packages
 sudo dnf remove -y lvm2 rng-tools thermald '*perl*' yajl

# Disable openh264 repo
sudo dnf config-manager --set-disabled fedora-cisco-openh264

# Install custom packages
sudo dnf install qubes-u2f qubes-gpg-split arc-theme qt5ct qt5-qtstyleplugins -y
echo "countme=False" | sudo tee -a /etc/dnf/dnf.conf

# Blacklisting kernel modules
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf | sudo tee /etc/modprobe.d/30_security-misc.conf
sudo sed -i 's/#install msr/install msr/g' /etc/modprobe.d/30_security-misc.conf

# Security kernel settings.
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/990-security-misc.conf | sudo tee /etc/sysctl.d/990-security-misc.conf
sudo sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /etc/sysctl.d/990-security-misc.conf
curl --proxy http://127.00.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_silent-kernel-printk.conf | sudo tee /etc/sysctl.d/30_silent-kernel-printk.conf
curl --proxy http://127.00.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_security-misc_kexec-disable.conf | sudo tee /etc/sysctl.d/30_security-misc_kexec-disable.conf

# Systemd hardening
sudo mkdir -p /etc/systemd/system/ModemManager.service.d
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/divestedcg/Brace/master/brace/usr/lib/systemd/system/ModemManager.service.d/99-brace.conf | sudo tee /etc/systemd/system/ModemManager.service.d/99-brace.conf

# Setup SSH client
echo "GSSAPIAuthentication no" | sudo tee /etc/ssh/ssh_config.d/10-custom.conf
echo "VerifyHostKeyDNS yes" | sudo tee -a /etc/ssh/ssh_config.d/10-custom.conf

# Force DNSSEC
sudo sed -i 's/#DNSSEC=no/DNSSEC=yes/g' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

# Theming

echo "export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

echo "[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'

[org/gnome/desktop/media-handling]
automount=false
automount-open=false" | sudo tee /etc/dconf/db/local.d/custom

sudo dconf update

# Flatpak update service

echo "[Unit]
Description=Update user Flatpaks

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak --user update -y

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/user/update-user-flatpaks.service

echo "[Unit]
Description=Update user Flatpaks daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target" | sudo tee /etc/systemd/user/update-user-flatpaks.timer
