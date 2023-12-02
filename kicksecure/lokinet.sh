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

#DNS doesn't work on an AppVM if Lokinet is used in a ProxyVM so Lokinet has to be installed on the AppVM
#The AppVM needs to be granted the network-manager service
#There is a risk of leaks because I dont see any killswitch being implemented

#Disabling the Arc icon theme here because it looks bad on the systray
sudo rm -rf /usr/share/icons/Arc

echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-3.0/settings.ini

echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1" | sudo tee /etc/gtk-4.0/settings.ini


#Actual Installtion
curl --proxy http://127.0.0.1:8082 | sudo tee /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg
echo "deb https://deb.oxen.io $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/oxen.list
curl --proxy http://127.0.0.1:8082 | sudo tee /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install --no-install-recommends brave-browser lokinet-gui resolvconf
sudo sed -i 's/#exit-node=/exit-node=exit.loki/' /var/lib/lokinet/lokinet.ini
sudo systemctl enable --now lokinet
