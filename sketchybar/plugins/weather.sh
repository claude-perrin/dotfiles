#!/usr/bin/env sh
# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting
LOCATION="Gliwice" # set to your location
weather=`curl -s "https://wttr.in/${LOCATION}?format=3" |gsed 's|  *| |g'`

sketchybar --set $NAME label="${weather}" \
	   --set $NAME click_script="/usr/bin/open /System/Applications/Weather.app"

