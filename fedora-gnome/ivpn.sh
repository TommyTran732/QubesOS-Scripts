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

set -e

unpriv(){
  sudo -u nobody "$@"
}

sudo dnf config-manager --add-repo https://repo.ivpn.net/stable/fedora/generic/ivpn.repo
sudo dnf install -y ivpn-ui

umask 022

sudo mkdir -p /etc/qubes-bind-dirs.d
echo 'binds+=( '\'''/etc/opt/ivpn/mutable''\'' )' | sudo tee /etc/qubes-bind-dirs.d/50_user.conf 

sudo mkdir /-p etc/systemd/system/systemd-resolved.service.d
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/system/systemd-resolved.service.d/override.conf | sudo tee /etc/systemd/system/systemd-resolved.service.d/override.conf > /dev/null

unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/system/dnat-to-ns.service | sudo tee /etc/systemd/system/dnat-to-ns.service > /dev/null
unpriv curl -s --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/system/dnat-to-ns.path | sudo tee /etc/systemd/system/dnat-to-ns.path > /dev/null

sudo systemctl enable dnat-to-ns.path

# Follow these instructions on how to set up the ProxyVM: https://privsec.dev/posts/qubes/using-ivpn-on-qubes-os/#creating-the-proxyvm