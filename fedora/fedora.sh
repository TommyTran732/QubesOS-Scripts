#!/bin/bash

sudo dnf remove firefox thunderbird totem gnome-remote-desktop gnome-calendar gnome-disk-utility gnome-calculators gnome-weather gnome-contacts gnome-clocks gnome-maps gnome-screenshot gnome-logs gnome-character gnome-font-viewer gnome-color-manager simple-scan keepassxc cheese baobab yelp evince* gedit httpd mozilla* -y
sudo dnf autoremove -y
sudo dnf install qubes-u2f qubes-gpg-split arc-theme qt5ct qt5-qtstyleplugins -y
echo "countme=false" | sudo tee -a /etc/dnf/dnf.conf

git config --global http.proxy http://127.0.0.1:8082
git clone https://github.com/horst3180/arc-icon-theme
sudo mv arc-icon-theme/Arc /usr/share/icons
rm -rf arc-icon-theme

echo "export export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

sudo cat > /etc/dconf/db/local.d/custom <<- 'EOF'
[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'
icon-theme='Arc'
EOF

sudo cat > /etc/systemd/user/update-user-flatpaks.service <<- 'EOF'
[Unit]
Description=Update user Flatpaks

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak --user update -y

[Install]
WantedBy=default.target
EOF

sudo cat > /etc/systemd/user/update-user-flatpaks.timer <<- 'EOF'
[Unit]
Description=Update user Flatpaks daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF