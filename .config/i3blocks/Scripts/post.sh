#!/bin/bash

# Get Pywal's colors from colors.json
BG_COLOR=$(jq -r '.background' ~/.cache/wal/colors.json)
TEXT_COLOR_LIGHT=$(jq -r '.color7' ~/.cache/wal/colors.json)  # Light color
TEXT_COLOR_DARK=$(jq -r '.color0' ~/.cache/wal/colors.json)    # Dark color

# Ensure colors are valid
if [[ ! $BG_COLOR =~ ^#[0-9A-Fa-f]{6}$ ]]; then BG_COLOR="#000000"; fi
if [[ ! $TEXT_COLOR_LIGHT =~ ^#[0-9A-Fa-f]{6}$ ]]; then TEXT_COLOR_LIGHT="#FFFFFF"; fi
if [[ ! $TEXT_COLOR_DARK =~ ^#[0-9A-Fa-f]{6}$ ]]; then TEXT_COLOR_DARK="#000000"; fi

# Calculate background brightness
BG_BRIGHTNESS=$(python3 -c "
color = '$BG_COLOR'.lstrip('#')
r, g, b = [int(color[i:i+2], 16) for i in (0, 2, 4)]
brightness = (r * 299 + g * 587 + b * 114) / 1000
print(int(brightness))
")

# Choose text color for best contrast
if [ "$BG_BRIGHTNESS" -lt 128 ]; then
    TEXT_COLOR="$TEXT_COLOR_LIGHT"  # Light text for dark backgrounds
else
    TEXT_COLOR="$TEXT_COLOR_DARK"   # Dark text for light backgrounds
fi

# Update i3blocks config to add or modify `color=` in each block
CONFIG_FILE=~/.config/i3blocks/config

# Backup the original config
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# Add "color=" in each block
awk -v text_color="$TEXT_COLOR" '
/^\[/ { in_block=1; print }
/^color=/ { next }  # Remove existing color lines
/^[a-zA-Z0-9_-]+\]/ && in_block { print "color=" text_color; in_block=0 }
!/^\[/ && !/^color=/ { print }
' "$CONFIG_FILE.bak" > "$CONFIG_FILE"

# Restart i3blocks to apply changes
i3-msg restart

