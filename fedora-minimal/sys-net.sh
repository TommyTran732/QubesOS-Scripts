#!/bin/bash

sudo dnf install -y qubes-core-agent-networking qubes-core-agent-network-manager NetworkManager-wifi network-manager-applet notification-daemon gnome-keyring @hardware-support chrony arc-theme

sudo systemctl disable --now systemd-timesyncd

#Configuration copied from https://github.com/GrapheneOS/infrastructure/blob/main/chrony.conf

echo 'server time.cloudflare.com iburst nts
server nts1.time.nl iburst nts
server sth1.nts.netnod.se iburst nts
server ptbtime1.ptb.de iburst nts

minsources 2
authselectmode require

driftfile /var/lib/chrony/drift
ntsdumpdir /var/lib/chrony

leapsectz right/UTC
makestep 1.0 3

rtconutc
rtcsync

cmdport 0' | sudo tee /etc/chrony.conf

sudo systemctl enable --now chronyd

sudo mkdir -p /etc/gtk-3.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir -p /etc/gtk-4.0
echo '[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
' | sudo tee /etc/gtk-4.0/settings.ini
