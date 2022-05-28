#!/bin/bash

sudo dnf config-manager --enable rpmfusion-nonfree
sudo dnf config-manager --enable rpmfusion-nonfree-updates
sudo dnf install -y discord
