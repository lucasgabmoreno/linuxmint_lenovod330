#!/bin/bash
# Auto rotate screen based on device orientation
# based on https://linuxappfinder.com/blog/auto_screen_rotation_in_ubuntu

# install
# 1. apt-get install iio-sensor-proxy inotify-tools
# 2. add script to autostart

# Receives input from monitor-sensor (part of iio-sensor-proxy package)
# Screen orientation and launcher location is set based upon accelerometer position
# Launcher will be on the left in a landscape orientation and on the bottom in a portrait orientation
# This script should be added to startup applications for the user

# may change grep to match your touchscreen
INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen")


#xrandr -o normal
#xrandr --output DSI-1 --mode 800x600
#xrandr --output DSI-1 --mode 800x1280
#xrandr --output DSI-1 --auto
#xrandr -o left
#xrandr -o right
#-s 800x1280 -r 60 
#&& xrandr --output DSI-1 --mode 800x1280 --rate 60.00
xrandr -o normal
xrandr -o right 
xinput set-prop "$INDEV" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1

sleep 5

LOG=/run/user/$(id -u $USER)/sensor.log
export DISPLAY=:0


function rotate {
	ORIENTATION=$1

	NEW_ROT="normal"
	CTM="1 0 0 0 1 0 0 0 1"

	# Set the actions to be taken  for each possible orientation
	case "$ORIENTATION" in
	normal)
        NEW_ROT="right"
        #NEW_ROT=("normal" "right") #va
        #NEW_ROT=("normal" "inverted" "right") #va
		CTM="0 1 0 -1 0 1 0 0 1"		
		;;
	bottom-up)
		NEW_ROT="left"
        #NEW_ROT=("left" "left")
        #NEW_ROT=("normal" "inverted" "left")
		CTM="0 -1 1 1 0 0 0 0 1"
		;;
	right-up)
		NEW_ROT="inverted"
        #NEW_ROT=("left" "inverted") #va
		#NEW_ROT=("left" "right" "inverted") #va
        CTM="-1 0 1 0 -1 1 0 0 1"
		;;
	left-up)
		NEW_ROT="normal"
        #NEW_ROT=("normal" "normal" "normal")        
        #NEW_ROT=("right" "left" "normal")
		CTM="1 0 0 0 1 0 0 0 1"
		;;
	esac  
#        xrandr -o normal
#       xrandr --output DSI-1 --mode 800x600
#       xrandr --output DSI-1 --mode 800x1280
#        xrandr -o normal
#        sleep 0.25
#        xrandr -o ${NEW_ROT[0]}
#        xrandr -o ${NEW_ROT[1]}         
        #xrandr -o normal
        #xrandr -o ${NEW_ROT[2]}
 		#xrandr -o $NEW_ROT
        #xrandr -o $NEW_ROT && xrandr --output DSI-1 --mode "800x1280_60.00"

        #$(xrandr --query --verbose | grep "DSI-1" | cut -d ' ' -f 6)   PROBAR CON ESTO!!!
        xrandr -o $NEW_ROT -s 800x1280 -r 60
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
