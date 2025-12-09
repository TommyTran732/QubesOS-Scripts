#!/bin/sh

# Copyright (C) 2024-2025 Thien Tran
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
  run0 -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | run0 tee "${2}" > /dev/null
}

umask 022

run0 mkdir -p /etc/qubes-bind-dirs.d
echo 'binds+=( '\'''/etc/loki''\'' )' | run0 tee /etc/qubes-bind-dirs.d/50_user.conf 

# Add repositories
download https://deb.oxen.io/pub.gpg /usr/share/keyrings/oxen.gpg
echo "deb [signed-by=/usr/share/keyrings/oxen.gpg] https://deb.oxen.io $(lsb_release -sc) main" | run0 tee /etc/apt/sources.list.d/oxen.list

download https://repository.mullvad.net/deb/mullvad-keyring.asc /usr/share/keyrings/mullvad-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list

# Install packages
run0 apt-get update
run0 apt-get install -y lokinet mullvad-browser resolvconf

download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/system/lokinet-dns-fix.service /etc/systemd/system/lokinet-dns-fix.service
run0 systemctl enable --now lokinet-dns-fix
