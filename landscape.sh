#!/bin/bash

INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen")
xrandr -o normal
xrandr -o right
xinput set-prop "$INDEV" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
