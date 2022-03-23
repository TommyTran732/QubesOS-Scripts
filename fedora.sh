#!/bin/bash

sudo dnf remove firefox thunderbird totem gnome-remote-desktop gnome-calendar gnome-calculators gnome-weather gnome-contacts gnome-clocks gnome-maps gnome-screenshot gnome-logs gnome-character gnome-font-viewer gnome-color-manager simple-scan keepassxc cheese baobab yelp evince* -y
sudo dnf autoremove -y
sudo dnf install arc-theme qubes-u2f -y
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
curl --proxy http://127.0.0.1:8082 https://brave-browser-rpm-release.s3.brave.com/brave-core.asc > brave-core.asc
sudo rpm --import brave-core.asc
rm -rf brave-core.asc
echo "gpgcheck=1" | sudo tee /etc/yum.repos.d/brave-browser-rpm-release.s3.brave.com_x86_64_.repo
sudo dnf install brave-browser yubikey-manager-qt yubioath-desktop ntfs-3g exfatprogs -y

git config --global http.proxy http://127.0.0.1:8082
git clone https://github.com/horst3180/arc-icon-theme
mv arc-icon-theme/Arc /usr/share/icons
rm -rf arc-icon-theme

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

sudo cat > /etc/dconf/db/local.d/custom <<- 'EOF'
[org/gnome/desktop/interface]
gtk-theme='Arc-Dark'
icon-theme='Arc'
EOF

sudo dconf update
