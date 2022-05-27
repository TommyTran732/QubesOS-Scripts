#!/bin/bash

curl --proxy http://127.0.0.1:8082/ -O https://protonvpn.com/download/protonvpn-stable-release_1.0.1-1_all.deb
sudo apt install --no-install-recommends ./protonvpn-stable-release_1.0.1-1_all.deb -y
sudo apt update
sudo apt install --no-install-recommends protonvpn -y