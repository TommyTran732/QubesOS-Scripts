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

set -eu

unpriv(){
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

download https://packages.element.io/debian/element-io-archive-keyring.gpg /usr/share/keyrings/element-io-archive-keyring.gpg
download https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/refs/heads/main/etc/apt/sources.list.d/element-io.sources /etc/apt/sources.list.d/element-io.sources

sudo apt update
sudo apt install -y element-desktop