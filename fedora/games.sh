#!/bin/bash

echo "color-scheme='prefer-dark'" | sudo tee -a /etc/dconf/local.d/custom
sudo dconf update

sudo dnf install -y gnome-chess gnome-2048 gnome-mines