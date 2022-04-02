#!/bin/bash

INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen") # Touchscreen
DNAME=$(xrandr --listmonitors | sed -ne 's/ .* //gp') # Monitor
MODE=$(echo $(xrandr | grep '*') | awk -F " " '{print $1; exit}') # Resolution 
RATE=$(echo $(xrandr | grep '*') | awk -F " " '{print $2; exit}' | sed 's/\*+//') # Rate Hz
BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Brightness
GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Gamma

xrandr --output $DNAME --mode $MODE --rate $RATE --gamma $GAMMA --brightness $BRIGHT --primary --rotate normal  
xrandr --output $DNAME --mode $MODE --rate $RATE --gamma $GAMMA --brightness $BRIGHT --primary --rotate right 
xinput set-prop "$INDEV" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
