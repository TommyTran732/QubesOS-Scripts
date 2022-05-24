#!/bin/bash

sudo dnf install thunderbird -y

#Do this in the AppVM after you have set it up
#Obviously replace sys-usb with the actual GPG backend that you are using https://www.qubes-os.org/doc/split-gpg/
#sudo echo "sys-usb" > /rw/config/gpg-split-domain
