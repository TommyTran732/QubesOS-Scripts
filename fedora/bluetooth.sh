#!/bin/bash

sudo sed -i 's/install bluetooth/#install bluetooth/g' /etc/modprobe/30_security-misc.conf
sudo sed -i 's/install btusb/#install btusb/g' /etc/modprobe/30_security-misc.conf
