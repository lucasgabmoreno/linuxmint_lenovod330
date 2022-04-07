#!/bin/bash

INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen") # Touchscreen
BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Brightness
GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Gamma
#DNAME=$(xrandr --listmonitors | sed -ne 's/ .* //gp') # Monitor
#MODE=$(echo $(xrandr | grep '*') | awk -F " " '{print $1; exit}') # Resolution 
#RATE=$(echo $(xrandr | grep '*') | awk -F " " '{print $2; exit}' | sed 's/\*+//') # Rate Hz
DNAME=DSI-1 # Monitor
MODE_PRE=1024x768 # Pre resolution
MODE=800x1280 # Resolution 
RATE_PRE=60.04 # Pre Rate Hz
RATE=60.00 # Rate Hz

xrandr --output $DNAME --mode $MODE_PRE --rate $RATE_PRE --gamma $GAMMA --brightness $BRIGHT --primary --rotate right
xrandr --output $DNAME --mode $MODE --rate $RATE --gamma $GAMMA --brightness $BRIGHT --primary --rotate right 
xinput set-prop "$INDEV" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1

