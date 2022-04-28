#!/bin/bash

# Fix Lenovo Ideapad D330-10IGL default camera
# Created for Linux Mint Cinnamon

# Copy this file into /usr/bin/ folder
# Copy lenovod330-10igl-webcam.service into /etc/systemd/system/ folder
# sudo chmod +x /usr/bin/lenovod330-10igl-webcam.sh
# sudo chmod +x /etc/systemd/system/lenovod330-10igl-webcam.service
# sudo systemctl enable lenovod330-10igl-webcam.service
# sudo systemctl start lenovod330-10igl-webcam.service
# reboot

# FRONT 2M CAMERA DEFAULT
# Remove back 5M camera
sudo rm -rf /dev/video0
sudo rm -rf /dev/video1
