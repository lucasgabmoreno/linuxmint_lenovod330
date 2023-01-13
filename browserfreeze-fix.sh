#!/bin/bash

# Copy this file into /usr/bin/ folder
# sudo chmod +x /usr/bin/browserfreeze-fix.sh
# Add to startup

rm -rf /home/$USER/.cache/chromium
rm -rf /home/$USER/.cache/mozilla/firefox
rm -rf /home/$USER/.cache/google-chrome

