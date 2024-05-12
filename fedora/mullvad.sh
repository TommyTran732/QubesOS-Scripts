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

sudo dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo
sudo dnf install -y mullvad-vpn
sudo systemctl enable mullvad-daemon

sudo mkdir -p /etc/qubes-bind-dirs.d
echo 'binds+=( '\'''/etc/mullvad-vpn''\'' )' | sudo tee /etc/qubes-bind-dirs.d/50_user.conf 

# Run these in the AppVM:
# echo "sleep 10 # Waiting a bit so that Mullvad can establish connection
# /usr/lib/qubes/qubes-setup-dnat-to-ns" | sudo tee -a /rw/config/rc.local
