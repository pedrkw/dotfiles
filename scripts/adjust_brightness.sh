#!/bin/bash

# This script controls the screen brightness using ddcutil.
#
# Usage:
#   ./brightness.sh increase       -> Increases brightness by 10%
#   ./brightness.sh decrease       -> Decreases brightness by 10%
#   ./brightness.sh <value>        -> Sets brightness to a specific value (0-100)
#   ./brightness.sh                -> Displays the current brightness

# Get the current brightness
current_brightness=$(ddcutil getvcp 0x10 | awk -F'current value = *|, *' '{print $2}')

# Check if ddcutil command succeeded
if [ -z "$current_brightness" ]; then
    echo "Error: Unable to retrieve current brightness."
    exit 1
fi

# Ensure brightness is within expected range
if [ "$current_brightness" -lt 0 ] || [ "$current_brightness" -gt 100 ]; then
    echo "Error: Current brightness is out of expected range (0-100)."
    exit 1
fi

# If no argument is provided, display current brightness
if [ "$#" -eq 0 ]; then
    echo "Current brightness: $current_brightness%"
    notify-send "Brightness Level" "Current brightness: $current_brightness%"
    exit 0
fi

# Read the parameter
action=$1

# Determine new brightness level
if [[ "$action" == "increase" ]]; then
    new_brightness=$((current_brightness + 10))
    [ "$new_brightness" -gt 100 ] && new_brightness=100
elif [[ "$action" == "decrease" ]]; then
    new_brightness=$((current_brightness - 10))
    [ "$new_brightness" -lt 0 ] && new_brightness=0
elif [[ "$action" =~ ^[0-9]+$ ]]; then
    new_brightness=$action
    if [ "$new_brightness" -lt 0 ] || [ "$new_brightness" -gt 100 ]; then
        echo "Error: Brightness value must be between 0 and 100."
        exit 1
    fi
else
    echo "Error: Parameter must be 'increase', 'decrease', or a numeric value (0-100)."
    exit 1
fi

# Set the new brightness level
ddcutil --display 1 setvcp 0x10 "$new_brightness"

# Notify user
notify-send "Brightness" "Brightness set to $new_brightness%"
echo "Brightness set to $new_brightness%"
