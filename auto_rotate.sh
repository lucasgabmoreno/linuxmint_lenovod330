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

sleep 5 # avoid ladnscape.sh script

INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen") # Touchscreen
#DNAME=$(xrandr --listmonitors | sed -ne 's/ .* //gp') # Monitor
#MODE=$(echo $(xrandr | grep '*') | awk -F " " '{print $1; exit}') # Resolution 
#RATE=$(echo $(xrandr | grep '*') | awk -F " " '{print $2; exit}' | sed 's/\*+//') # Rate Hz
DNAME=DSI-1 # Monitor
MODE_PRE=1024x768 # Pre resolution
MODE=800x1280 # Resolution 
RATE_PRE=60.04 # Pre Rate Hz
RATE=60.00 # Rate Hz

LOG=/run/user/$(id -u $USER)/sensor.log
export DISPLAY=:0

function rotate {
	ORIENTATION=$1
    NOW_ROT=$(xrandr --query --verbose | grep "$DNAME" | cut -d ' ' -f 6)

	case "$NOW_ROT" in
	normal)
        ROT_NORMAL=false
        ROT_RIGHT=true
        ROT_INVERTED=false
        ROT_LEFT=true
		;;
	right)
        ROT_NORMAL=true
        ROT_RIGHT=false
        ROT_INVERTED=true
        ROT_LEFT=false
		;;
	inverted)
        ROT_NORMAL=false
        ROT_RIGHT=true
        ROT_INVERTED=false
        ROT_LEFT=true
		;;
	left)  
        ROT_NORMAL=true
        ROT_RIGHT=false
        ROT_INVERTED=true
        ROT_LEFT=false
		;;
	esac  	

	# Set the actions to be taken  for each possible orientation
	case "$ORIENTATION" in
	normal)
        ROT=$ROT_RIGHT        
        NEW_ROT="right"
		CTM="0 1 0 -1 0 1 0 0 1" 		
		;;
	bottom-up)
        ROT=$ROT_LEFT 
		NEW_ROT="left"
		CTM="0 -1 1 1 0 0 0 0 1"
		;;
	right-up)
        ROT=$ROT_INVERTED
		NEW_ROT="inverted"
        CTM="-1 0 1 0 -1 1 0 0 1"
		;;
	left-up)
        ROT=$ROT_NORMAL
		NEW_ROT="normal"
		CTM="1 0 0 0 1 0 0 0 1"
		;;
	esac  

    BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Brightness
    GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Gamma

if $ROT; then    
    xrandr --output $DNAME --mode $MODE_PRE --rate $RATE_PRE --gamma $GAMMA --brightness $BRIGHT --primary --rotate $NEW_ROT    
fi

    xrandr --output $DNAME --mode $MODE --rate $RATE --gamma $GAMMA --brightness $BRIGHT --primary --rotate $NEW_ROT
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
        sleep 0.25
        ORIENTATION=$(tail -n 1 $LOG | grep 'orientation' | grep -oE '[^ ]+$')
        rotate $ORIENTATION
	fi

done
