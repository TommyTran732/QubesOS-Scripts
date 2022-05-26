#!/bin/bash

sudo apt update
sudo apt full-upgrade
sudo addgroup --system console
sudo adduser user console

curl --proxy http://127.0.0.1:8082/ --tlsv1.3 --proto =https --max-time 180 --output ~/derivative.asc https://www.kicksecure.com/derivative.asc
sudo cp ~/derivative.asc /usr/share/keyrings/derivative.asc
echo "deb [signed-by=/usr/share/keyrings/derivative.asc] https://deb.kicksecure.com bullseye main contrib non-free" | sudo tee /etc/apt/sources.list.d/derivative.list

sudo apt install kicksecure-qubes-cli
sudo mv /etc/apt/sources.list ~/
sudo touch /etc/apt/sources.list
