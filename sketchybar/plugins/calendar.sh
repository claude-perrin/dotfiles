#!/bin/bash
current_hour=$(date '+%H')
if [ $current_hour -gt 21 ]; then
    hour_color=0xffD22B2B
    sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')" label.color=$hour_color
fi
sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"
