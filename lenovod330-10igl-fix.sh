#!/bin/bash

# Fix Lenovo Ideapad D330-10IGL
# Only works in the last 4.19.x kernel
# Created for Linux Mint Cinnamon

# Install dependencies:
# sudo apt-get install inotify-tools -y

# Copy this file into /usr/bin/ folder
# Copy lenovod330-10igl-fix.service into /etc/systemd/system/ folder
# sudo chmod +x /usr/bin/lenovod330-10igl-fix.sh
# sudo chmod +x /etc/systemd/system/lenovod330-10igl-fix.service
# sudo systemctl enable lenovod330-10igl-fix.service
# sudo systemctl start lenovod330-10igl-fix.service

# Open Keyboard options > Keyboard shortcuts > Custom Shortcuts
# Add new one:
    # Name: Refresh Screen
    # Order: /usr/bin/lenovod330-10igl-refreshscreen.sh
    # Keyboard bindings: Control+Shift+R


# FRONT 2M CAMERA DEFAULT
# Backup video
if [ ! -f /dev/video0.bak ]; then
    sudo cp /dev/video0 /dev/video0.bak # back camera
    sudo cp /dev/video1 /dev/video1.bak # back camera
    sudo cp /dev/video2 /dev/video2.bak # front camera
    sudo cp /dev/video3 /dev/video3.bak # front camera
fi
# Remove default video
    sudo rm -rf /dev/video0
    sudo rm -rf /dev/video1
    sudo rm -rf /dev/video2
    sudo rm -rf /dev/video3
# Invert default video
    sudo cp /dev/video0.bak /dev/video2
    sudo cp /dev/video1.bak /dev/video3
    sudo cp /dev/video2.bak /dev/video0
    sudo cp /dev/video3.bak /dev/video1


# DISPLAY
INDEV=$(xinput list --id-only "pointer:Goodix Capacitive TouchScreen") # Actual Touchscreen
BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Actual Brightness
GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Actual Gamma
DNAME=DSI-1 # Monitor
MODE=800x1280R # Resolution 
RATE=59.91 # Rate Hz


# NEW DISPLAY MODE
xrandr --newmode "800x1280R" 75.75  800 848 880 960  1280 1283 1293 1317 +hsync -vsync
xrandr --addmode DSI-1 800x1280R


# LANDSCAPE DEFAULT
xrandr -s 0 # Reset xrandr
xrandr --output $DNAME --auto --primary --mode $MODE --rotate right  # Landscape rotate
xrandr --output $DNAME --rate $RATE --gamma $GAMMA --brightness $BRIGHT # Final fixes
xinput set-prop "$INDEV" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1 # Landscape touchscreen


# AUTOROTATE
# Based on https://gist.github.com/Links2004/5976ce97a14dabf773c3ff98d03c0f61 

LOG=/run/user/$(id -u $USER)/sensor.log

function rotate {
	ORIENTATION=$1
    NOW_ROT=$(xrandr --query --verbose | grep "$DNAME" | cut -d ' ' -f 6) # Actual rotation

    # If 180° rotate, doesn't reset screen
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

	# Set the actions to be taken for each possible orientation
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

    BRIGHT=$(echo $(xrandr --verbose | grep 'Brightness') | awk -F " " '{print $2; exit}') # Actual Brightness
    GAMMA=$(echo $(xrandr --verbose | grep 'Gamma') | awk -F " " '{print $2; exit}') # Actual Gamma

    if $ROT; then        
        xrandr -s 0 # Reset screen | Needs 4.19.x kernel        
    fi

    xrandr --output $DNAME --auto --primary --mode $MODE --rotate $NEW_ROT # Rotate screen
    xrandr --output $DNAME --rate $RATE --gamma $GAMMA --brightness $BRIGHT # Final fixes
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
