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

set -eu -o pipefail

unpriv(){
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

sudo dnf install -y https://github.com/manga-download/hakuneko/releases/download/nightly-20200705.1/hakuneko-desktop_8.3.4_linux_amd64.rpm
sudo dnf config-manager --enable fedora-cisco-openh264 rpmfusion-free rpmfusion-free-updates rpmfusion-nonfree rpmfusion-nonfree-updates
sudo dnf upgrade -y
sudo dnf install -y ffmpeg yt-dlp