#!/bin/bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.font="$FONT:Regular:19.0"
  padding_right=5
  padding_left=3
  icon.padding_right=9
  label.width=34
  label.align=right
  label.drawing=on
  update_freq=120
  updates=on
)
sketchybar --add item battery right      \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke
