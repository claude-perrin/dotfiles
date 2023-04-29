#!/bin/bash
current_hour=$(date '+%H')
if [ $current_hour -gt 21 ]; then
    hour_color=0xffD22B2B # Red
else
    hour_color=0xffcad3f5 # White
fi
sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')" label.color=$hour_color
