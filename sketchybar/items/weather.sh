#!/bin/bash

weather=(
  script="$PLUGIN_DIR/weather.sh"
)

sketchybar  --add item weather right                              \
            --set weather update_freq=300                        \
             script="$PLUGIN_DIR/weather.sh"                     \
             y_offset=2

