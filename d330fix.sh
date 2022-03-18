#!/bin/bash
#RESET DEFAULT
xrandr -o normal

#FIX
xrandr -o right
TOUCHSCREEN_ID=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen")
xinput set-prop "$TOUCHSCREEN_ID" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
