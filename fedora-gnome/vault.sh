#!/bin/sh

# Copyright (C) 2022-2025 Thien Tran
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

download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/qubes-rpc/qubes.SshAgent /etc/qubes-rpc/qubes.SshAgent
run0 chmod +x /etc/qubes-rpc/qubes.SshAgent

# Not using openssh-askpass here, because of this bug:
# https://github.com/QubesOS/qubes-issues/issues/9741

run0 dnf install -y keepassxc okular pinentry-gnome3
