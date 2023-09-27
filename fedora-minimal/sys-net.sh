#!/bin/bash

# Copyright (C) 2023 Thien Tran
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

dnf install -y qubes-core-agent-networking qubes-core-agent-network-manager NetworkManager-wifi network-manager-applet notification-daemon gnome-keyring @hardware-support chrony arc-theme

systemctl disable --now systemd-timesyncd
rm -rf /etc/chrony.conf
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /etc/chrony.conf
systemctl enable --now chronyd

#Switch DNSSEC to default / allow-downgrade, as there is no guaranteee that the DNS server obtained via DHCP supports DNSSEC.
sed -i 's/DNSSEC=yes/#DNSSEC=false/g' /etc/systemd/resolved.conf
systemctl restart systemd-resolved

#Theming

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

echo '[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=${CONNECTION}/${BOOT}
' | sudo tee /etc/NetworkManager/conf.d/00-macrandomize.conf
