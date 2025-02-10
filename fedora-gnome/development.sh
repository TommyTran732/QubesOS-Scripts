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

# Base this on the microsoft-edge TemplateVM

set -eu -o pipefail

unpriv(){
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

echo '[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode/
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc' | sudo tee /etc/yum.repos.d/vscode.repo

echo '[shiftkey-packages]
name=GitHub Desktop
baseurl=https://rpm.packages.shiftkey.dev/rpm/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://rpm.packages.shiftkey.dev/gpg.key' | sudo tee /etc/yum.repos.d/shiftkey-packages.repo

sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install -y code docker-ce docker-compose-plugin github-desktop

# Change the GPG Domain name appropriately
echo 'QUBES_GPG_DOMAIN=vault' | sudo tee -a /etc/environment

umask 022

sudo mkdir -p /etc/qubes-bind-dirs.d
echo 'binds+=( '\'''/var/lib/docker''\'' )' | sudo tee /etc/qubes-bind-dirs.d/50_user.conf 