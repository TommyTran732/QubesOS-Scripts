#!/bin/bash

curl --proxy http://127.0.0.1:8082 -O https://packages.microsoft.com/keys/microsoft.asc
sudo rpm --import microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo dnf install -y microsoft-edge-stable
