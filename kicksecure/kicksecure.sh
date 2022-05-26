#!/bin/bash
#Adding KickSecure's signing key
curl --proxy http://127.0.0.1:8082/ --tlsv1.3 --proto =https --max-time 180 --output ~/derivative.asc https://www.kicksecure.com/derivative.asc
sudo cp ~/derivative.asc /usr/share/keyrings/derivative.asc
echo "deb [signed-by=/usr/share/keyrings/derivative.asc] https://deb.kicksecure.com bullseye main contrib non-free" | sudo tee /etc/apt/sources.list.d/derivative.list

#Debloat
sudo apt purge -y thunderbird emacs emacs-gtk emacs-bin-common emacs-common firefox* keepassxc cups* system-config-printer* xsettingsd xterm* yelp*
sudo apt autoremove -y
sudo apt autoclean

#Distribution morphing
sudo addgroup --system console
sudo adduser user console
sudo adduser user sudo
sudo apt install --no-install-recommends kicksecure-qubes-cli -y
sudo mv /etc/apt/sources.list ~/
sudo touch /etc/apt/sources.list

#Enabling SUID Disabler and Permission Hardener
sudo systemctl enable --now permission-hardening

#Install LKRG
sudo apt install --no-install-recommends lkrg-dkms linux-headers-amd64 -y

#Enable hardened malloc
echo "/usr/lib/libhardened_malloc.so/libhardened_malloc.so" | sudo tee /etc/ld.so.preload

#Reduce kernel information leaks
#Will break a lot of applications. The apps I use on KickSecure work fine with it so I am enabling it.
sudo systemctl enable --now hide-hardware-info.service

#Install packages
sudo apt install --no-install-recommends qubes-gpg-split qubes-u2f eog qt5ct qt5-style-plugins arc-theme -y

#Theming
git config --global http.proxy http://127.0.0.1:8082
git clone https://github.com/horst3180/arc-icon-theme
sudo mv arc-icon-theme/Arc /usr/share/icons
rm -rf arc-icon-theme

echo "export QT_QPA_PLATFORMTHEME=gtk2" | sudo tee /etc/environment

sudo mkdir /etc/gtk-3.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Arc-Dark" | sudo tee /etc/gtk-3.0/settings.ini

sudo mkdir /etc/gtk-4.0
echo "[Settings]
gtk-theme-name=Arc-Dark
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Arc" | sudo tee /etc/gtk-4.0/settings.ini

#Flatpak update service

echo "[Unit]
Description=Update user Flatpaks

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak --user update -y

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/user/update-user-flatpaks.service

echo "[Unit]
Description=Update user Flatpaks daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target" | sudo tee /etc/systemd/user/update-user-flatpaks.timer