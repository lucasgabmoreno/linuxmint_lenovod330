#!/bin/bash

# Fix Lenovo Ideapad D330-10IGL default camera
# Created for Linux Mint Cinnamon

# Dependencies
# sudo apt install v4l-utils -y

# Copy this file into /usr/bin/ folder
# Copy lenovod330-10igl-webcam.service into /etc/systemd/system/ folder
# sudo chmod +x /usr/bin/lenovod330-10igl-webcam.sh
# sudo chmod +x /etc/systemd/system/lenovod330-10igl-webcam.service
# sudo systemctl enable lenovod330-10igl-webcam.service
# sudo systemctl start lenovod330-10igl-webcam.service
# reboot

if [[ $(v4l2-ctl --info --device /dev/video0 | grep Model) == *5M* ]]
then
sudo mv /dev/video0 /dev/video10
sudo mv /dev/video1 /dev/video11
sudo mv /dev/video2 /dev/video0
sudo mv /dev/video3 /dev/video1
sudo mv /dev/video10 /dev/video2
sudo mv /dev/video11 /dev/video3
fi
