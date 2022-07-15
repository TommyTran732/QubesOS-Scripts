#!/bin/bash

#This needs to be run as a standalone VM

#Also a couple of things: 
#RiseUp does appear to be some sort of communist/socialist/anarchist activist organization, I am not really sure. 
#I am not that much into politics, and I am certainly not an activist, so I don't really know or care much about any of this stuff.
#In any case, I only made this script because it is one of the few VPN (oh, free one too) that has a working client on QubesOS.
#Obfs4proxy support is also fancy, it may come in handy one day.
#Don't take this as my recommendation to use RiseUp because I have zero clue how trustworthy they are or if you are gonna paint a
#target on your back by associating with an organization promoting an ideology that your government doesn't like.

sudo dnf install -y snapd qubes-snapd-helper lxpolkit
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install riseup-vpn --classic
