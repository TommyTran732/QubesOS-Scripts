#!/bin/bash

sudo dnf install -y nextcloud-client

#Adding a DNS entry for my Nextcloud server here so I can add a Firewall rule locking the AppVM to only being able to connect to my server.
echo "5.226.143.92 cloud.tommytran.io" | sudo tee -a /etc/hosts
