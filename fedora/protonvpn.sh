#!/bin/bash

curl --proxy http://127.0.0.1:8082/ -O https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm
sudo dnf install protonvpn -y