#!/bin/bash

#Enabling SUID Disabler and Permission Hardener
sudo systemctl enable --now permission-hardening

#Install LKRG
sudo apt install --no-install-recommends linux-headers-amd64 lkrg-dkms tirdad -y

#Enable hardened malloc
echo "/usr/lib/libhardened_malloc.so/libhardened_malloc.so" | sudo tee /etc/ld.so.preload

#Reduce kernel information leaks
#Will break a lot of applications. The apps I use on Whonix work fine with it so I am enabling it.
sudo systemctl enable --now hide-hardware-info.service
