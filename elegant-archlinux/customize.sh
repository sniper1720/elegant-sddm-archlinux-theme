#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
THEME_NAME="elegant-archlinux"
THEME_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$THEME_DIR/theme.conf.user"

echo -e "${GREEN}"
echo "+---------------------------------------------+"
echo "|      ELEGANT SDDM THEME CUSTOMIZER          |"
echo "|       Crafted with ❤️ by sniper1720         |"
echo "+---------------------------------------------+"
echo -e "${NC}"

if [ ! -w "$THEME_DIR" ]; then
    echo -e "${RED}Error: Cannot write to theme directory.$NC"
    echo "Please run this script as root (sudo)."
    exit 1
fi

echo "Customizing theme at: $THEME_DIR"

# Blur Strength Selection
echo
echo "Choose background blur strength:"
echo "1. None (0.0) - Sharp"
echo "2. Medium (0.5) - Balanced"
echo "3. Strong (1.0) - Blurred [Default]"
read -p "Enter selection [1-3]: " -n 1 -r < /dev/tty
echo

BLUR_VAL="1.0"
if [[ $REPLY =~ ^[1]$ ]]; then
    BLUR_VAL="0.0"
elif [[ $REPLY =~ ^[2]$ ]]; then
    BLUR_VAL="0.5"
fi

if grep -q "BlurStrength=" "$CONFIG_FILE" 2>/dev/null; then
    sed -i "s|^BlurStrength=.*|BlurStrength=$BLUR_VAL|" "$CONFIG_FILE"
else
    if [ ! -f "$CONFIG_FILE" ]; then
            echo "[General]" > "$CONFIG_FILE"
    fi
    echo "BlurStrength=$BLUR_VAL" >> "$CONFIG_FILE"
fi

echo -e "${GREEN}Configuration saved!${NC}"

# Activation Logic
read -p "Do you want to ACTIVATE the theme now? [y/N] " -n 1 -r < /dev/tty
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    CONFIG_DIR="/etc/sddm.conf.d"
    TARGET_CONF=""
    
    if [ -f "$CONFIG_DIR/kde_settings.conf" ]; then
        TARGET_CONF="$CONFIG_DIR/kde_settings.conf"
    elif [ -f "$CONFIG_DIR/theme.conf.user" ]; then
            TARGET_CONF="$CONFIG_DIR/theme.conf.user"
    elif [ -f "$CONFIG_DIR/theme.conf" ]; then
            TARGET_CONF="$CONFIG_DIR/theme.conf"
    else
            TARGET_CONF="$CONFIG_DIR/theme.conf"
    fi
    
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
    fi
    
    for f in "$CONFIG_DIR"/*.conf; do
        if [[ "$f" != "$TARGET_CONF" ]] && grep -q "Current=" "$f"; then
            echo -e "${RED}Warning: Cleaned up conflicting config: $f${NC}"
            rm "$f"
        fi
    done

    if grep -q "^\[Theme\]" "$TARGET_CONF"; then
            if grep -q "Current=" "$TARGET_CONF"; then
                sed -i "s|^Current=.*|Current=$THEME_NAME|" "$TARGET_CONF"
            else
                sed -i "/^\[Theme\]/a Current=$THEME_NAME" "$TARGET_CONF"
            fi
    else
            echo -e "\n[Theme]\nCurrent=$THEME_NAME" >> "$TARGET_CONF"
    fi
    
    echo -e "${GREEN}Theme activated in $TARGET_CONF!${NC}"
    
    if [ -f "$CONFIG_DIR/virtualkeyboard.conf" ]; then
            echo
            echo -e "${RED}Found Config for Virtual Keyboard ($CONFIG_DIR/virtualkeyboard.conf).${NC}"
            echo "This file often causes the on-screen keyboard to pop up unnecessarily."
            read -p "Do you want to remove it? [y/N] " -n 1 -r < /dev/tty
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm "$CONFIG_DIR/virtualkeyboard.conf"
                echo -e "${GREEN}Removed virtualkeyboard.conf${NC}"
            else
                echo "Skipped removal of virtualkeyboard.conf"
            fi
    fi

else
    echo "Done. Don't forget to restart SDDM!"
fi
