#!/bin/sh

# Copyright (C) 2024 Thien Tran
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

set -eu -o pipefail

unpriv(){
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

sudo dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 rpmfusion-free.enabled=1 rpmfusion-free-updates.enabled=1 rpmfusion-nonfree.enabled=1 rpmfusion-nonfree-updates.enabled=1

# Install the package
sudo dnf install -y ffmpeg ffmpegthumbnailer mullvad-browser
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Disable hardened_malloc (for now)
# It causes Mullvad browser to randomly crash
sudo rm /etc/ld.so.preload
