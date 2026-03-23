#!/bin/bash

POPUP_SCRIPT="sketchybar -m --set calendar.event popup.drawing=toggle"

calendar_event=(
  icon=$CALENDAR_EVENT
  icon.font="$FONT:Bold:14.0"
  icon.color=$BLUE
  label.font="$FONT:Semibold:12.0"
  label.color=$WHITE
  padding_left=$PADDINGS
  padding_right=$PADDINGS
  drawing=off
  update_freq=300
  popup.align=center
  click_script="$POPUP_SCRIPT"
  script="$PLUGIN_DIR/calendar_event.sh"
)

calendar_popup_item=(
  icon.drawing=off
  label.font="$FONT:Semibold:12.0"
  label.color=$WHITE
  label.padding_left=8
  label.padding_right=8
  background.height=26
  background.corner_radius=9
  drawing=off
)

sketchybar --add item calendar.event right                          \
           --set calendar.event "${calendar_event[@]}"              \
           --subscribe calendar.event system_woke                   \
                                      mouse.entered                 \
                                      mouse.exited                  \
                                      mouse.exited.global           \
                                                                    \
           --add item calendar.popup.1 popup.calendar.event         \
           --set calendar.popup.1 "${calendar_popup_item[@]}"       \
           --add item calendar.popup.2 popup.calendar.event         \
           --set calendar.popup.2 "${calendar_popup_item[@]}"       \
           --add item calendar.popup.3 popup.calendar.event         \
           --set calendar.popup.3 "${calendar_popup_item[@]}"       \
           --add item calendar.popup.4 popup.calendar.event         \
           --set calendar.popup.4 "${calendar_popup_item[@]}"       \
           --add item calendar.popup.5 popup.calendar.event         \
           --set calendar.popup.5 "${calendar_popup_item[@]}"
