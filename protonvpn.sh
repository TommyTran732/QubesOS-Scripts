#!/bin/bash 

#Base this on fedora-X-minimal-sys-net
sudo dnf install https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
sudo dnf install protonvpn NetworkManager-openvpn -y
