#!/bin/bash

if [[ $(v4l2-ctl --info --device /dev/video0 | grep Model) == *5M* ]]
then
sudo mv /dev/video0 /dev/video10
sudo mv /dev/video1 /dev/video11
sudo mv /dev/video2 /dev/video0
sudo mv /dev/video3 /dev/video1
sudo mv /dev/video10 /dev/video2
sudo mv /dev/video11 /dev/video3
fi
