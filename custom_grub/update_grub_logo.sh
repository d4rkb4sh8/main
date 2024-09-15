#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Variables
CUSTOM_LOGO="hacker-logo.png"
GRUB_THEME_DIR="/boot/grub/themes/custom_theme"
GRUB_CONFIG="/etc/default/grub"

# Create the theme directory if it doesn't exist
mkdir -p $GRUB_THEME_DIR

# Convert the custom logo to the required size and format
convert $CUSTOM_LOGO -resize 400x400 -background none -gravity center -extent 400x400 $GRUB_THEME_DIR/background.png

# Create a loading glow effect (this is a simple example, you can enhance it)
convert $GRUB_THEME_DIR/background.png \( +clone -fill white -colorize 100% -alpha off -draw "circle 200,200 200,50" \) -compose DstOut -composite $GRUB_THEME_DIR/background_glow.png

# Create a GRUB2 theme configuration file
cat <<EOL > $GRUB_THEME_DIR/theme.txt
title-text: ""
title-color: "#ffffff"
desktop-color: "#000000"
terminal-box: "terminal_box_hidden"
terminal-font: "Unifont Regular 16"
terminal-left: "0"
terminal-top: "0"
terminal-width: "100%"
terminal-height: "100%"
image: "background_glow.png"
image-width: "400"
image-height: "400"
image-position: "center"
EOL

# Update GRUB configuration to use the custom theme
if ! grep -q "GRUB_THEME=" $GRUB_CONFIG; then
    echo "GRUB_THEME=\"$GRUB_THEME_DIR/theme.txt\"" >> $GRUB_CONFIG
else
    sed -i "s|GRUB_THEME=.*|GRUB_THEME=\"$GRUB_THEME_DIR/theme.txt\"|" $GRUB_CONFIG
fi

# Update GRUB
update-grub

echo "GRUB2 has been updated with the custom logo and loading glow effect."
