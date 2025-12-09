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

set -eu

unpriv(){
  run0 -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | run0 tee "${2}" > /dev/null
}

echo '[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode/
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc' | run0 tee /etc/yum.repos.d/vscode.repo

echo '[shiftkey-packages]
name=GitHub Desktop
baseurl=https://rpm.packages.shiftkey.dev/rpm/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://rpm.packages.shiftkey.dev/gpg.key' | run0 tee /etc/yum.repos.d/shiftkey-packages.repo

run0 dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

run0 dnf install -y butane code docker-ce docker-buildx-plugin docker-compose-plugin git github-desktop

run0 systemctl enable --now docker
run0 usermod -aG docker user

# Change the GPG Domain name appropriately
echo 'QUBES_GPG_DOMAIN=vault' | run0 tee -a /etc/environment

umask 022

run0 mkdir -p /etc/qubes-bind-dirs.d
echo 'binds+=( '\'''/var/lib/docker''\'' )' | run0 tee /etc/qubes-bind-dirs.d/50_user.conf 
