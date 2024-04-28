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

# Compliance
systemctl mask debug-shell.service
systemctl mask kdump.service

# Setting umask to 077
umask 077
sed -i 's/umask 022/umask 077/g' /etc/bashrc
echo 'umask 077' | tee -a /etc/bashrc

# Disable timesyncd
systemctl disable --now systemd-timesyncd
systemctl mask systemd-timesyncd

# Security kernel settings
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf | tee /etc/modprobe.d/30_security-misc.conf
chmod 644 /etc/modprobe.d/30_security-misc.conf
sed -i 's/#install msr/install msr/g' /etc/modprobe.d/30_security-misc.conf
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/990-security-misc.conf | tee /etc/sysctl.d/990-security-misc.conf
chmod 644 /etc/sysctl.d/990-security-misc.conf
sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /etc/sysctl.d/990-security-misc.conf
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_silent-kernel-printk.conf | tee /etc/sysctl.d/30_silent-kernel-printk.conf
chmod 644 /etc/sysctl.d/30_silent-kernel-printk.conf
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_security-misc_kexec-disable.conf | tee /etc/sysctl.d/30_security-misc_kexec-disable.conf
chmod 644 /etc/sysctl.d/30_security-misc_kexec-disable.conf
# Dracut doesn't seem to work - need to investigate
# dracut -f
sysctl -p

# Harden SSH
curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/ssh/ssh_config.d/10-custom.conf | tee /etc/ssh/ssh_config.d/10-custom.conf
chmod 644 /etc/ssh/ssh_config.d/10-custom.conf