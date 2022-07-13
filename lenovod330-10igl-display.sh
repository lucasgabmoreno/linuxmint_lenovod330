#!/bin/bash

# Fix Lenovo Ideapad D330 Display
# Only works in the last 4.19.x kernel
# Created for Linux Mint Cinnamon

# Install dependencies:
# sudo apt-get install inotify-tools -y

# Copy this file into /usr/bin/ folder
# sudo chmod +x /usr/bin/lenovod330-10igl-display.sh
# Add this script to startup 

# Actual screen
INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen") # Actual Touchscreen
BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Actual Brightness
GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Actual Gamma
DNAME=$(xrandr --listmonitors | sed -ne 's/ .* //gp') # Actual Monitor
MODE=$(echo $(xrandr | grep '*') | awk -F " " '{print $1; exit}') # Actual Resolution 
MODE_WIDTH=$(echo $MODE | awk -F "x" '{print $1; exit}') # Width 
MODE_HEIGHT=$(echo $MODE | awk -F "x" '{print $2; exit}') # Height
RATE=$(echo $(xrandr | grep '*') | awk -F " " '{print $2; exit}' | sed 's/\*+//') # Actual Rate Hz
ROT=$(xrandr --query --verbose | grep "$DNAME" | cut -d ' ' -f 6) # Actual Rotate

# New mode
RATE_NEW=-r
MODELINE=$(cvt $MODE_WIDTH $MODE_HEIGHT $RATE_NEW | grep 'Modeline')
MODE_NEW=$(echo $MODELINE | awk -F " " '{print $2; exit}')
xrandr --newmode $(echo $MODELINE| awk -F " " '{print $2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13; exit}')
xrandr --addmode $DNAME $MODE_NEW 
sleep 0.5

# Default mode
xrandr --output $DNAME --off
xrandr --output $DNAME --mode $MODE_NEW --rotate right
xrandr --output $DNAME --gamma $GAMMA --brightness $BRIGHT # Final fixes
xinput set-prop "$INDEV" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1 # Landscape touchscreen

# AUTOROTATE
# Based on https://gist.github.com/Links2004/5976ce97a14dabf773c3ff98d03c0f61 

LOG=/run/user/$(id -u $USER)/sensor.log

function rotate {
	ORIENTATION=$1

	# Set the actions to be taken for each possible orientation
	case "$ORIENTATION" in
	normal)  
        ROT_NEW="right"
		CTM="0 1 0 -1 0 1 0 0 1" 		
		;;
	bottom-up) 
		ROT_NEW="left"
		CTM="0 -1 1 1 0 0 0 0 1"
		;;
	right-up)
		ROT_NEW="inverted"
        CTM="-1 0 1 0 -1 1 0 0 1"
		;;
	left-up)
		ROT_NEW="normal"
		CTM="1 0 0 0 1 0 0 0 1"
		;;
	esac  

    BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Actual Brightness
    GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Actual Gamma

    xrandr --output $DNAME --mode $MODE_NEW --rotate $ROT_NEW # Rotate screen
    xrandr --output $DNAME --gamma $GAMMA --brightness $BRIGHT # Final fixes
    xinput set-prop "$INDEV" --type=float 'Coordinate Transformation Matrix' $CTM # Touchscreen matrix rotate
}

# kill old monitor-sensor
killall monitor-sensor

# Clear sensor.log so it doesn't get too long over time
> $LOG

# Launch monitor-sensor and store the output in a variable that can be parsed by the rest of the script
monitor-sensor >> $LOG 2>&1 &

while inotifywait -e modify $LOG; do
    if ! $(gsettings get org.cinnamon.settings-daemon.peripherals.touchscreen orientation-lock); then # Cinnamon display auto-rotate setting
	    ORIENTATION=$(tail -n 1 $LOG | grep 'orientation' | grep -oE '[^ ]+$')
	    if [ ! -z $ORIENTATION ] ; then
            sleep 0.25
            ORIENTATION=$(tail -n 1 $LOG | grep 'orientation' | grep -oE '[^ ]+$')
            rotate $ORIENTATION
	    fi
    fi
done
