#!/bin/bash 

sudo cat > /etc/dconf/db/local.d/custom <<- 'EOF'
[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'
EOF

sudo dnf install https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm -y
sudo dnf install protonvpn -y
