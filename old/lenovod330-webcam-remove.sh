#!/bin/bash

if [[ $(v4l2-ctl --info --device /dev/video0 | grep Model) == *5M* ]]
then
sudo rm -rf /dev/video0
sudo rm -rf /dev/video1
sudo mv /dev/video2 /dev/video0
sudo mv /dev/video3 /dev/video1
fi
