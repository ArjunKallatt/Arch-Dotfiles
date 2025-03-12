#!/bin/sh

# Extract foreground color (color7 is usually used for text)
COLOR=$(jq -r '.colors.color7' ~/.cache/wal/colors.json)

# Convert color to brightness level
BRIGHTNESS=$(echo $COLOR | convert - -colorspace HSL -format "%[fx:int(100*l)]" info:)

# Ensure good contrast for text
if [ "$BRIGHTNESS" -lt 30 ]; then
    COLOR="#FFFFFF"  # Too dark, use white
elif [ "$BRIGHTNESS" -gt 70 ]; then
    COLOR="#000000"  # Too bright, use black
fi

# Apply the color to i3blocks config
sed -i "s/^foreground=.*/foreground=$COLOR/" ~/.config/i3blocks/config
i3-msg restart

