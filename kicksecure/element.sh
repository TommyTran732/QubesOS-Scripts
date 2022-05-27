#!/bin/bash

sudo curl --proxy http://127.0.0.1:8082/ https://packages.element.io/debian/element-io-archive-keyring.gpg -o /usr/share/keyrings/element-io-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
sudo apt update
sudo apt install --no-install-recommends element-desktop -y

#Adding a DNS entry for my Matrix server here so I can add a Firewall rule locking the AppVM to only being able to connect to my server.
echo "5.226.143.168 matrix.arcticfoxes.net" | sudo tee -a /etc/hosts
