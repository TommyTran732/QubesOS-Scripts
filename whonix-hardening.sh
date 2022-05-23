#!/bin/bash

#Enabling SUID Disabler and Permission Hardener
systemctl enable --now permission-hardening

#Install LKRG
apt update
apt full-upgrade -y
sudo apt install --no-install-recommends lkrg-dkms linux-headers-amd64

#Enable hardened malloc
echo "/usr/lib/libhardened_malloc.so/libhardened_malloc.so" >> /etc/ld.so.preload
