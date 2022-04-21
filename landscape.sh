#!/bin/bash

INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen") # Touchscreen
BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Brightness
GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Gamma
#DNAME=$(xrandr --listmonitors | sed -ne 's/ .* //gp') # Monitor
#MODE=$(echo $(xrandr | grep '*') | awk -F " " '{print $1; exit}') # Resolution 
#RATE=$(echo $(xrandr | grep '*') | awk -F " " '{print $2; exit}' | sed 's/\*+//') # Rate Hz
DNAME=DSI-1 # Monitor
MODE=800x1280R # Resolution 
RATE=59.91 # Rate Hz

MODE_PRE=1280x800 # Pre resolution
RATE_PRE=59.99 # Pre Rate Hz
BRIGHT_PRE=1.0
GAMMA_PRE=1.0:1.0:1.0

xrandr --newmode "800x1280R" 75.75  800 848 880 960  1280 1283 1293 1317 +hsync -vsync
xrandr --addmode DSI-1 800x1280R

xrandr --output $DNAME --auto --primary --mode $MODE_PRE --rotate right
xrandr --output $DNAME --auto --primary --mode $MODE --rotate right
xrandr --output $DNAME --rate $RATE --gamma $GAMMA --brightness $BRIGHT

xinput set-prop "$INDEV" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1

