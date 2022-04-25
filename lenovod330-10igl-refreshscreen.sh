#!/bin/bash

# Refresh screen to try to fix black screen in Lenovo Ideapad D330-10IGL
# Only works for last 4.19.x kernel

# Copy this file into /usr/bin/ folder
# sudo chmod +x /usr/bin/lenovod330-10igl-refreshscreen.sh
# Open Keyboard options > Keyboard shortcuts > Custom Shortcuts
# Add new one:
    # Name: Refresh Screen
    # Order: /usr/bin/lenovod330-10igl-refreshscreen.sh
    # Keyboard bindings: Control+Shift+R

BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Actual Brightness
GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Actual Gamma
DNAME=$(xrandr --listmonitors | sed -ne 's/ .* //gp') # Actual Monitor
MODE=$(echo $(xrandr | grep '*') | awk -F " " '{print $1; exit}') # Actual Resolution 
RATE=$(echo $(xrandr | grep '*') | awk -F " " '{print $2; exit}' | sed 's/\*+//') # Actual Rate Hz
ROT=$(xrandr --query --verbose | grep "$DNAME" | cut -d ' ' -f 6) # Actual Rotate

xrandr -s 0 # Reset Xrandr
xrandr -s 0 --output $DNAME --auto --primary --mode $MODE --rotate $ROT --rate $RATE --gamma $GAMMA --brightness $BRIGHT
