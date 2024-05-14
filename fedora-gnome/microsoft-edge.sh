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

# Note: Qubes does something that makes the umask for root stay at 022. Need to debug. The umask commands are unnecessary for now.
umask 022

# Install Edge
echo '[microsoft-edge]
name=microsoft-edge
baseurl=https://packages.microsoft.com/yumrepos/edge/
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc' | sudo tee /etc/yum.repos.d/microsoft-edge.repo

sudo dnf install -y microsoft-edge-stable

sudo mkdir -p /etc/opt/edge/policies/managed/ /etc/opt/edge/policies/recommended/
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Microsoft-Edge-Policies/main/Linux/managed.json | sudo tee /etc/opt/edge/policies/managed/managed.json
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Microsoft-Edge-Policies/main/Linux/recommended.json | sudo tee /etc/opt/edge/policies/managed/recommended.json

# Work around for Edge audio bug
sudo dnf install -y pulseaudio-utils

echo '[Unit]
Description=Run pactl to work around edge audio bug
After=pipewire-pulse.socket
Requires=pipewire-pulse.socket

[Service]
Type=oneshot
ExecStart=/usr/bin/pactl info

[Install]
WantedBy=default.target' | sudo tee /etc/systemd/user/pactl.service

umask 077

# Run `systemctl --user enable --now pactl.service` in your appVM.
# For some uncomprehensible reason, manually enabling pipewire-pulse.service will not work for Edge audio.
# Using preset doesn't actually work :/