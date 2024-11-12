#!/bin/sh

set -eu

unpriv(){
  sudo -u nobody "${@}"
}

download() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}

umask 022

sudo mkdir -p /etc/qubes-bind-dirs.d
echo 'binds+=( '\'''/etc/loki''\'' )' | sudo tee /etc/qubes-bind-dirs.d/50_user.conf 

download https://deb.oxen.io/pub.gpg /usr/share/keyrings/oxen.gpg
echo "deb [signed-by=/usr/share/keyrings/oxen.gpg] https://deb.oxen.io $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/oxen.list

sudo apt update
sudo apt install lokinet resolvconf

download https://raw.githubusercontent.com/TommyTran732/QubesOS-Scripts/main/etc/systemd/system/lokinet-dns-fix.service /etc/systemd/system/lokinet-dns-fix.service
sudo systemctl enable --now lokinet-dns-fix