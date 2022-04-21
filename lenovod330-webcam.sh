#!/bin/bash

# Make default front camera

# Fix
sudo mv /dev/video0 /dev/video0.bak
sudo mv /dev/video1 /dev/video1.bak
sudo mv /dev/video2 /dev/video0
sudo mv /dev/video3 /dev/video1
sudo mv /dev/video0.bak /dev/video2
sudo mv /dev/video1.bak /dev/video3

# Remove
sudo rm -rf /etc/systemd/system/lenovod330-webcam.service
sudo rm -rf /usr/bin/lenovod330-webcam.sh

