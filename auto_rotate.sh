#!/bin/bash
# Auto rotate screen based on device orientation
# based on https://gist.github.com/Links2004/5976ce97a14dabf773c3ff98d03c0f61 
# Adapted for Lenovo D330 10IGL 82HO

# Install
# 1. apt-get install iio-sensor-proxy inotify-tools
# 2. add script to autostart

# Receives input from monitor-sensor (part of iio-sensor-proxy package)
# Screen orientation and launcher location is set based upon accelerometer position
# Launcher will be on the left in a landscape orientation and on the bottom in a portrait orientation
# This script should be added to startup applications for the user

# may change grep to match your touchscreen

sleep 5

INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen")
DNAME=DSI-1
LOG=/run/user/$(id -u $USER)/sensor.log
export DISPLAY=:0

function rotate {
	ORIENTATION=$1
    NOW_ROT=$(xrandr --query --verbose | grep "$DNAME" | cut -d ' ' -f 6)

    # Fix with 90° hack method 
	case "$NOW_ROT" in
	normal)
        ROT_NORMAL="normal"
        ROT_RIGHT="normal"
        ROT_INVERTED="normal"
        ROT_LEFT="normal"
		;;
	right)
        ROT_NORMAL="left"
        ROT_RIGHT="right"
        ROT_INVERTED="left"
        ROT_LEFT="right"
		;;
	inverted)
        ROT_NORMAL="inverted"
        ROT_RIGHT="inverted"
        ROT_INVERTED="inverted"
        ROT_LEFT="inverted"
		;;
	left)  
        ROT_NORMAL="right"
        ROT_RIGHT="left"
        ROT_INVERTED="left"
        ROT_LEFT="left"
		;;
	esac  	

	# Set the actions to be taken  for each possible orientation
	case "$ORIENTATION" in
	normal)
        OLD_ROT=$ROT_RIGHT        
        NEW_ROT="right"
		CTM="0 1 0 -1 0 1 0 0 1" 		
		;;
	bottom-up)
        OLD_ROT=$ROT_LEFT 
		NEW_ROT="left"
		CTM="0 -1 1 1 0 0 0 0 1"
		;;
	right-up)
        OLD_ROT=$ROT_INVERTED
		NEW_ROT="inverted"
        CTM="-1 0 1 0 -1 1 0 0 1"
		;;
	left-up)
        OLD_ROT=$ROT_NORMAL
		NEW_ROT="normal"
		CTM="1 0 0 0 1 0 0 0 1"
		;;
	esac  

    xrandr -o $OLD_ROT    
    xrandr -o $NEW_ROT
    xinput set-prop "$INDEV" --type=float 'Coordinate Transformation Matrix' $CTM
}

# kill old monitor-sensor
killall monitor-sensor

# Clear sensor.log so it doesn't get too long over time
> $LOG

# Launch monitor-sensor and store the output in a variable that can be parsed by the rest of the script
monitor-sensor >> $LOG 2>&1 &

# Parse output or monitor sensor to get the new orientation whenever the log file is updated
# Possibles are: normal, bottom-up, right-up, left-up
# Light data will be ignored
while inotifywait -e modify $LOG; do
	# Read the last line that was added to the file and get the orientation
	ORIENTATION=$(tail -n 1 $LOG | grep 'orientation' | grep -oE '[^ ]+$')

	if [ ! -z $ORIENTATION ] ; then
		rotate $ORIENTATION
	fi

done
