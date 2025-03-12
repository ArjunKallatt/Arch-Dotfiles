#!/bin/bash

# Define icons (Requires FontAwesome)
shutdown="  Shutdown"
reboot="  Reboot"
logout="  Logout"
suspend="  Suspend"
hibernate="  Hibernate"
lock="  Lock"
cancel="  Cancel"

# Properly format options for dmenu
OPTIONS=$(printf "%s\n" "$lock" "$suspend" "$hibernate" "$logout" "$reboot" "$shutdown" "$cancel")

# Show menu and store user choice
CHOICE=$(echo "$OPTIONS" | dmenu -i -p "  Power Menu: " -nb "#282828" -nf "#ebdbb2" -sb "#458588" -sf "#ffffff" -fn "monospace-12")

# Run the corresponding command
case "$CHOICE" in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$logout") i3-msg exit ;;
    "$suspend") systemctl suspend ;;
    "$hibernate") systemctl hibernate ;;
    "$lock") i3lock-fancy ;;
    "$cancel") exit 0 ;;
    *) exit 1 ;;  # Exit if no valid choice
esac

