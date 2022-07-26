#!/bin/bash
#DNS doesn't work on an AppVM if Lokinet is used in a ProxyVM so Lokinet has to be installed on the AppVM
#There is a risk of leaks because I dont see any killswitch being implemented

sudo curl --proxy http://127.0.0.1:8082 -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg
echo "deb https://deb.oxen.io $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/oxen.list
sudo curl --proxy http://127.0.0.1:8082 -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install --no-install-recommends brave-browser lokinet-gui
sudo sed -i 's/#exit-node=/exit-node=exit.loki/' /var/lib/lokinet/lokinet.ini
sudo systemctl enable --now lokinet
