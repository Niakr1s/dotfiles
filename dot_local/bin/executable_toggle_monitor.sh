#!/bin/bash

# Hyprland monitor toggle script

# We are using commands
# hyprctl monitors all | grep "Monitor <monitor>" -A 30 | grep disabled
# hyprctl keyword monitorv2[$RIGHT_MON]:disabled 0

monitor="$1"
if [ -z "$monitor" ]; then
  echo "No arguments specified. Specify your monitor name. It is shown in 'hyprctl monitors all' after 'Monitor' word"
  exit 1
fi

MONITORS=$(hyprctl monitors all)

get_monitor_disabled_status() {
  local monitor="$1"

  MONITOR_INFO=$(echo "$MONITORS" | grep "Monitor $monitor" -A 30)

  if echo "$MONITOR_INFO" | grep -q "disabled: true"; then
    echo "disabled"
  elif echo "$MONITOR_INFO" | grep -q "disabled: false"; then
    echo "enabled"
  fi
}

toggled_status() {
  local status="$1"

  if [ "$status" = "enabled" ]; then
    echo "disabled"
  else
    echo "enabled"
  fi
}

disabled_status_numeric() {
  local status="$1"


  if [ "$status" = "enabled" ]; then
    echo "0"
  else
    echo "1"
  fi
}

toggle_monitor() {
  local monitor="$1"
  local new_status="$2"
  hyprctl keyword monitorv2["$monitor"]:disabled "$new_status"
}


status=$(get_monitor_disabled_status "$monitor")
if [ -z "$status" ]; then
  echo "Monitor $monitor not found"
  exit 1
fi

new_status=$(toggled_status "$status")
echo "Toggling $monitor ($status -> $new_status)"

toggle_monitor "$monitor" $(disabled_status_numeric "$new_status")
