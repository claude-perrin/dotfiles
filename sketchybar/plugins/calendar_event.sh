#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Guard: icalBuddy must be installed
if ! command -v icalBuddy &>/dev/null; then
  sketchybar --set $NAME drawing=off
  exit 0
fi

MAX_TITLE_LEN=30
MAX_POPUP_TITLE=35
POPUP_SLOTS=5

truncate_text() {
  local text="$1"
  local max="$2"
  if [ ${#text} -gt $max ]; then
    echo "${text:0:$((max-1))}…"
  else
    echo "$text"
  fi
}

# Parse day prefix and time from an icalBuddy time line like "today at 15:30 - 16:00"
parse_time_line() {
  local time_line="$1"
  DAY="" TIME=""
  if [[ "$time_line" == tomorrow* ]]; then
    DAY="Tomorrow"
    TIME=$(echo "$time_line" | sed 's/^tomorrow at //' | sed 's/ -.*//')
  elif [[ "$time_line" == today* ]]; then
    DAY=""
    TIME=$(echo "$time_line" | sed 's/^today at //' | sed 's/ -.*//')
  else
    TIME=$(echo "$time_line" | sed 's/ -.*//')
  fi
}

update() {
  local output
  output=$(icalBuddy -n -li 1 -nc -ea -df "" -tf "%H:%M" \
    -iep "title,datetime" -b "" eventsToday+1 2>/dev/null)

  if [ -z "$output" ]; then
    sketchybar --set $NAME drawing=off
    return
  fi

  local title time_line
  title=$(echo "$output" | head -1 | sed 's/^[[:space:]]*//')
  time_line=$(echo "$output" | sed -n '2p' | sed 's/^[[:space:]]*//')

  parse_time_line "$time_line"
  title=$(truncate_text "$title" $MAX_TITLE_LEN)

  local label
  if [ -n "$DAY" ] && [ -n "$TIME" ]; then
    label="${title}  ${DAY} ${TIME}"
  elif [ -n "$TIME" ]; then
    label="${title}  ${TIME}"
  else
    label="${title}  All day"
  fi

  sketchybar --set $NAME drawing=on label="$label"
}

popup() {
  sketchybar -m --set calendar.event popup.drawing=$1
}

update_popup() {
  local output
  output=$(icalBuddy -n -li $POPUP_SLOTS -nc -ea -df "" -tf "%H:%M" \
    -iep "title,datetime" -b "" eventsToday+1 2>/dev/null)

  if [ -z "$output" ]; then
    sketchybar --set calendar.popup.1 drawing=on \
               label="No upcoming events" label.color=$GREY
    for i in $(seq 2 $POPUP_SLOTS); do
      sketchybar --set calendar.popup.$i drawing=off
    done
    return
  fi

  local slot=1
  local title=""
  while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]] ]]; then
      local time_line display
      time_line=$(echo "$line" | sed 's/^[[:space:]]*//')

      parse_time_line "$time_line"
      title=$(truncate_text "$title" $MAX_POPUP_TITLE)

      if [ -n "$DAY" ] && [ -n "$TIME" ]; then
        display="$DAY $TIME  $title"
      elif [ -n "$TIME" ]; then
        display="$TIME  $title"
      else
        display="All day  $title"
      fi

      sketchybar --set calendar.popup.$slot drawing=on \
                 label="$display" label.color=$WHITE
      slot=$((slot + 1))
      [ $slot -gt $POPUP_SLOTS ] && break
    else
      title=$(echo "$line" | sed 's/^[[:space:]]*//')
    fi
  done <<< "$output"

  while [ $slot -le $POPUP_SLOTS ]; do
    sketchybar --set calendar.popup.$slot drawing=off
    slot=$((slot + 1))
  done
}

case "$SENDER" in
  mouse.entered)
    popup on
    update_popup
    ;;
  mouse.exited|mouse.exited.global)
    popup off
    ;;
  *)
    update
    ;;
esac
