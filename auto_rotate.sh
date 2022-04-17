#!/bin/bash
# Based on https://gist.github.com/Links2004/5976ce97a14dabf773c3ff98d03c0f61 
# Adapted for Lenovo D330 10IGL 82HO

sleep 5 # avoid ladnscape.sh script

INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen") # Touchscreen
#DNAME=$(xrandr --listmonitors | sed -ne 's/ .* //gp') # Monitor
#MODE=$(echo $(xrandr | grep '*') | awk -F " " '{print $1; exit}') # Resolution 
#RATE=$(echo $(xrandr | grep '*') | awk -F " " '{print $2; exit}' | sed 's/\*+//') # Rate Hz
DNAME=DSI-1 # Monitor
MODE_PRE=1024x768 # Pre resolution
MODE=800x1280R # Resolution 
RATE_PRE=60.00 # Pre Rate Hz
RATE=59.91 # Rate Hz

LOG=/run/user/$(id -u $USER)/sensor.log
#export DISPLAY=:0

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
        xrandr -s 0
    fi
    xrandr --output $DNAME --auto --primary --mode $MODE --rotate $NEW_ROT --rate $RATE --gamma $GAMMA --brightness $BRIGHT
    xinput set-prop "$INDEV" --type=float 'Coordinate Transformation Matrix' $CTM
}

# kill old monitor-sensor
killall monitor-sensor

# Clear sensor.log so it doesn't get too long over time
> $LOG

# Launch monitor-sensor and store the output in a variable that can be parsed by the rest of the script
monitor-sensor >> $LOG 2>&1 &

while inotifywait -e modify $LOG; do
    if ! $(gsettings get org.cinnamon.settings-daemon.peripherals.touchscreen orientation-lock); then
	    ORIENTATION=$(tail -n 1 $LOG | grep 'orientation' | grep -oE '[^ ]+$')
	    if [ ! -z $ORIENTATION ] ; then
            sleep 0.25
            ORIENTATION=$(tail -n 1 $LOG | grep 'orientation' | grep -oE '[^ ]+$')
            rotate $ORIENTATION
	    fi
    fi
done
