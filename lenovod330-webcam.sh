#!/bin/bash

# Make default front camera

sudo mv /dev/video0 /dev/video0.bak
sudo mv /dev/video1 /dev/video1.bak
sudo mv /dev/video2 /dev/video0
sudo mv /dev/video3 /dev/video1
sudo mv /dev/video0.bak /dev/video2
sudo mv /dev/video1.bak /dev/video3
