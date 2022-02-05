#!/bin/bash

#For use with a template based on the Debian template

curl --proxy http://127.0.0.1:8082 https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

curl --proxy http://127.0.0.1:8082 https://packages.element.io/debian/element-io-archive-keyring.gpg | sudo tee -a /usr/share/keyrings/element-io-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list

sudo apt update 
sudo apt install signal-desktop element-desktop -y
