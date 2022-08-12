#!/bin/bash

#Needs to be based on the Edge template
curl --proxy http://127.0.0.1:8082 https://mirror.mwt.me/ghd/gpgkey -o shiftkey.asc
sudo rpm --import shiftkey.asc
sudo sh -c 'echo -e "[shiftkey]\nname=GitHub Desktop\nbaseurl=https://mirror.mwt.me/ghd/rpm\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://mirror.mwt.me/ghd/gpgkey" > /etc/yum.repos.d/shiftkey-desktop.repo'
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-compose-plugin github-desktop code java-latest-openjdk hugo
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker

sudo mkdir -p /etc/qubes-bind-dirs.d
sudo tee /etc/qubes-bind-dirs.d50_user.conf << EOF > /dev/null
binds+=( '/var/lib/docker' )
binds+=( '/etc/docker' )
EOF