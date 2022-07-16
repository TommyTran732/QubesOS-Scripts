#!/bin/bash

sudo dnf install thunderbird -y

#Remove if you don't use ProtonMail
sudo dnf install https://protonmail.com/download/bridge/protonmail-bridge-2.1.3-1.x86_64.rpm -y

#Do this in the AppVM after you have set it up
#Obviously replace vault-gpg with the actual GPG backend that you are using https://www.qubes-os.org/doc/split-gpg/
#echo "vault" | sudo tee /rw/config/gpg-split-domain
