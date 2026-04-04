#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Guard: icalBuddy must be installed
if ! command -v icalBuddy &>/dev/null; then
  sketchybar --set $NAME drawing=off
  exit 0
fi

MAX_POPUP_TITLE=35
TOTAL_POPUP_SLOTS=8

truncate_text() {
  local text="$1" max="$2"
  [ ${#text} -gt $max ] && echo "${text:0:$((max-1))}…" || echo "$text"
}

# Convert "today at HH:MM..." or "tomorrow at HH:MM..." to sort key (minutes since midnight).
# Strips leading "due: " if present. All-day / unrecognized → 0.
compute_sort_key() {
  local line="${1#due: }"
  local off=0 t=""
  if [[ "$line" == tomorrow* ]]; then
    off=1440; t=$(echo "$line" | sed 's/^tomorrow at //;s/ -.*//')
  elif [[ "$line" == today* ]]; then
    off=0;    t=$(echo "$line" | sed 's/^today at //;s/ -.*//')
  else
    echo 0; return
  fi
  local h m
  h=$(echo "$t" | cut -d: -f1); m=$(echo "$t" | cut -d: -f2)
  echo $((off + 10#$h * 60 + 10#$m))
}

# Sets DAY and TIME globals from a time line (strips "due: " prefix).
parse_time_fields() {
  local line="${1#due: }"
  DAY="" TIME=""
  if [[ "$line" == tomorrow* ]]; then
    DAY="Tomorrow"
    TIME=$(echo "$line" | sed 's/^tomorrow at //;s/ -.*//')
  elif [[ "$line" == today* ]]; then
    TIME=$(echo "$line" | sed 's/^today at //;s/ -.*//')
  fi
}

# Prints sorted "SORTKEY|DISPLAY|COLOR" lines for events + timed reminders.
build_combined() {
  local -a items=()

  # --- Calendar events (today + tomorrow) ---
  local ev
  ev=$(icalBuddy -n -li 6 -nc -ea -df "" -tf "%H:%M" \
    -iep "title,datetime" -b "" eventsToday+1 2>/dev/null)

  if [ -n "$ev" ]; then
    local etitle=""
    while IFS= read -r line; do
      if [[ "$line" =~ ^[[:space:]] ]]; then
        [ -z "$etitle" ] && continue
        local tl key display
        tl=$(echo "$line" | sed 's/^[[:space:]]*//')
        key=$(compute_sort_key "$tl")
        parse_time_fields "$tl"
        etitle=$(truncate_text "$etitle" $MAX_POPUP_TITLE)
        if [ -n "$DAY" ] && [ -n "$TIME" ]; then
          display="$DAY $TIME  $etitle"
        elif [ -n "$TIME" ]; then
          display="$TIME  $etitle"
        else
          display="All day  $etitle"
        fi
        items+=("${key}|${display}|${WHITE}")
        etitle=""
      else
        etitle=$(echo "$line" | sed 's/^[[:space:]]*//')
      fi
    done <<< "$ev"
  fi

  # --- Reminders: only those with an explicit due time today or tomorrow ---
  local rem
  rem=$(icalBuddy -n -li 6 -nc -ea -df "" -tf "%H:%M" \
    -iep "title,dueDate" -b "" uncompletedTasks 2>/dev/null)

  if [ -n "$rem" ]; then
    local rtitle=""
    while IFS= read -r line; do
      if [[ "$line" =~ ^[[:space:]] ]]; then
        [ -z "$rtitle" ] && continue
        local dl
        dl=$(echo "$line" | sed 's/^[[:space:]]*//')
        # Only include if due today or tomorrow with a specific time
        if [[ "$dl" == "due: today at "* ]] || [[ "$dl" == "due: tomorrow at "* ]]; then
          local key display
          key=$(compute_sort_key "$dl")
          parse_time_fields "$dl"
          rtitle=$(truncate_text "$rtitle" $MAX_POPUP_TITLE)
          [ -n "$DAY" ] && display="$DAY $TIME  $rtitle" || display="$TIME  $rtitle"
          items+=("${key}|${display}|${YELLOW}")
        fi
        rtitle=""
      else
        # New title — previous one (if any) had no due-date line, so skip it
        rtitle=$(echo "$line" | sed 's/^[[:space:]]*//')
      fi
    done <<< "$rem"
  fi

  [ ${#items[@]} -gt 0 ] && printf '%s\n' "${items[@]}" | sort -t'|' -k1 -n
}

popup() {
  sketchybar -m --set calendar.event popup.drawing=$1
}

update() {
  local first
  first=$(build_combined | head -1)

  if [ -z "$first" ]; then
    sketchybar --set $NAME drawing=off
    return
  fi

  local display color
  display=$(echo "$first" | cut -d'|' -f2)
  color=$(echo "$first"  | cut -d'|' -f3)
  sketchybar --set $NAME drawing=on label="$display" label.color="$color"
}

update_popup() {
  local sorted
  sorted=$(build_combined)

  if [ -z "$sorted" ]; then
    sketchybar --set calendar.popup.1 drawing=on \
               label="No upcoming events" label.color=$GREY
    for i in $(seq 2 $TOTAL_POPUP_SLOTS); do
      sketchybar --set calendar.popup.$i drawing=off
    done
    return
  fi

  local slot=1
  while IFS= read -r item; do
    local disp color
    disp=$(echo "$item"  | cut -d'|' -f2)
    color=$(echo "$item" | cut -d'|' -f3)
    sketchybar --set calendar.popup.$slot drawing=on \
               label="$disp" label.color="$color"
    slot=$((slot + 1))
    [ $slot -gt $TOTAL_POPUP_SLOTS ] && break
  done <<< "$sorted"

  while [ $slot -le $TOTAL_POPUP_SLOTS ]; do
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
