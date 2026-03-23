#!/bin/bash

# this is jank and ugly, I know
LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"
echo ${LAYOUT}

# specify short layouts individually.
case "$LAYOUT" in
    '"Ukrainian-PC"') SHORT_LAYOUT="УК";;
    "ABC") SHORT_LAYOUT="US";;
    "Russian") SHORT_LAYOUT="РУ";;
    *) SHORT_LAYOUT="??";;
esac

sketchybar --set keyboard label="$SHORT_LAYOUT"
