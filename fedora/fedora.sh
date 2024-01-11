#!/bin/bash

sudo dnf remove firefox thunderbird totem gnome-remote-desktop gnome-calendar gnome-disk-utility gnome-calculator gnome-connections gnome-weather gnome-contacts gnome-clocks gnome-maps gnome-screenshot gnome-logs gnome-characters gnome-font-viewer gnome-color-manager simple-scan keepassxc cheese baobab yelp evince* httpd mozilla* cups rygel -y
sudo dnf autoremove -y
sudo dnf install qubes-u2f qubes-gpg-split arc-theme qt5ct qt5-qtstyleplugins -y
echo "countme=False" | sudo tee -a /etc/dnf/dnf.conf

# Blacklisting kernel modules
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf | sudo tee /etc/modprobe.d/30_security-misc.conf

# Security kernel settings.
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/990-security-misc.conf | sudo tee /etc/sysctl.d/990-security-misc.conf
sudo sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /etc/sysctl.d/990-security-misc.conf
curl --proxy http://127.00.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_silent-kernel-printk.conf | sudo tee /etc/sysctl.d/30_silent-kernel-printk.conf
curl --proxy http://127.00.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_security-misc_kexec-disable.conf | sudo tee /etc/sysctl.d/30_security-misc_kexec-disable.conf

# Systemd hardening
sudo mkdir -p /etc/systemd/system/ModemManager.service.d
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/divestedcg/Brace/master/brace/usr/lib/systemd/system/ModemManager.service.d/99-brace.conf | sudo tee /etc/systemd/system/ModemManager.service.d/99-brace.conf

#Setup SSH client
echo "GSSAPIAuthentication no" | sudo tee /etc/ssh/ssh_config.d/10-custom.conf
echo "VerifyHostKeyDNS yes" | sudo tee -a /etc/ssh/ssh_config.d/10-custom.conf

#Force DNSSEC
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

#Flatpak update service

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
