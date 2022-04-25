#!/bin/bash

# Fix Lenovo Ideapad D330-10IGL
# Only works in the last 4.19.x kernel
# Created for Linux Mint Cinnamon

# Install dependencies:
# sudo apt-get install inotify-tools -y

# Copy this file into /usr/bin/ folder
# Copy lenovod330-10igl-fix.service into /etc/systemd/system/ folder
# sudo chmod +x /usr/bin/lenovod330-10igl-fix.sh
# sudo chmod +x /etc/systemd/system/lenovod330-10igl-fix.service
# sudo systemctl enable lenovod330-10igl-fix.service
# sudo systemctl start lenovod330-10igl-fix.service

# Open Keyboard options > Keyboard shortcuts > Custom Shortcuts
# Add new one:
    # Name: Refresh Screen
    # Order: /usr/bin/lenovod330-10igl-refreshscreen.sh
    # Keyboard bindings: Control+Shift+R


# FRONT 2M CAMERA DEFAULT
# Backup video
if [ ! -f /dev/video0.bak ]; then
    sudo cp /dev/video0 /dev/video0.bak # back camera
    sudo cp /dev/video1 /dev/video1.bak # back camera
    sudo cp /dev/video2 /dev/video2.bak # front camera
    sudo cp /dev/video3 /dev/video3.bak # front camera
fi
# Remove default video
    sudo rm -rf /dev/video0
    sudo rm -rf /dev/video1
    sudo rm -rf /dev/video2
    sudo rm -rf /dev/video3
# Invert default video
    sudo cp /dev/video0.bak /dev/video2
    sudo cp /dev/video1.bak /dev/video3
    sudo cp /dev/video2.bak /dev/video0
    sudo cp /dev/video3.bak /dev/video1

