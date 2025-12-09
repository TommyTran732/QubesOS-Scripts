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

run0 dnf config-manager addrepo --from-repofile=https://repo.secureblue.dev/secureblue.repo
run0 dnf config-manager setopt fedora-cisco-openh264.enabled=1 rpmfusion-free.enabled=1 rpmfusion-free-updates.enabled=1 rpmfusion-nonfree.enabled=1 rpmfusion-nonfree-updates.enabled=1
run0 dnf install -y ffmpeg trivalent
run0 dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

umask 022

# Workaround for this problem: https://forum.qubes-os.org/t/upgraded-to-4-2-and-audio-no-longer-works/23130/60
run0 dnf install -y pulseaudio-utils

echo '[Unit]
Description=Run pactl to work around edge audio bug
After=pipewire-pulse.socket
Requires=pipewire-pulse.socket

[Service]
Type=oneshot
ExecStart=/usr/bin/pactl info

[Install]
WantedBy=default.target' | run0 tee /etc/systemd/user/pactl.service

umask 077

# Run `systemctl --user enable --now pactl.service` in your appVM.
# For some uncomprehensible reason, manually enabling pipewire-pulse.service will not work for Edge audio.
# Using preset doesn't actually work :/
