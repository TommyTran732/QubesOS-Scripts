#!/bin/bash

#Run this in the appVM
sudo mkdir -p /etc/qubes-bind-dirs.d
sudo tee /etc/qubes-bind-dirs.d50_user.conf << EOF > /dev/null
binds+=( '/var/lib/docker' )
binds+=( '/etc/docker' )
EOF