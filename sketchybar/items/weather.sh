#!/bin/bash

weather=(
  label=?
  padding_right=10
  script="$PLUGIN_DIR/weather.sh"
)

sketchybar  --add item weather right                              \
                    --set weather update_freq=900                        \
                         script="$PLUGIN_DIR/weather.sh"         

