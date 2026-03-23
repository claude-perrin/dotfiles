#!/usr/bin/env sh
# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting
weather=$(curl -s "https://wttr.in/?format=%c%t" | gsed 's|  *| |g')

sketchybar --set $NAME label="${weather}" \
	   --set $NAME click_script="/usr/bin/open /System/Applications/Weather.app"

