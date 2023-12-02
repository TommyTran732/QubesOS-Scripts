#!/bin/bash

curl --proxy http://127.0.0.1:8082 -O https://packages.microsoft.com/keys/microsoft.asc
sudo rpm --import microsoft.asc
rm microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo dnf install -y microsoft-edge-stable
sudo mkdir -p /etc/opt/edge/policies/managed/ /etc/opt/edge/policies/recommended/
sudo curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Microsoft-Edge-Policies/main/Linux/managed.json -o /etc/opt/edge/policies/managed/managed.json
sudo curl --proxy http://127.0.0.1:8082 https://raw.githubusercontent.com/TommyTran732/Microsoft-Edge-Policies/main/Linux/recommended.json -o /etc/opt/edge/policies/managed/recommended.json
