#!/bin/bash

bat_files="/sys/class/power_supply/BAT1"
bat_status=$(cat ${bat_files}/status)
capacity=$(cat "${bat_files}/capacity")

if [[ ${bat_status}=="Discharging" && ${capacity} -le 20 ]]; then
    echo "Battery alert - ${capacity}%"
    notify-send \
        --icon=battery-low \
        "Low battery" \
        "Only ${capacity}% battery remaining"
fi
