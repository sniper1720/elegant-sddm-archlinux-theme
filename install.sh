#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

REPO_URL="https://github.com/sniper1720/elegant-sddm-archlinux-theme.git"
THEME_NAME="elegant-archlinux"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"

echo -e "${GREEN}"
echo "+---------------------------------------------+"
echo "|          ELEGANT SDDM THEME v1.2.0            |"
echo "|       Crafted with ❤️ by sniper1720         |"
echo "+---------------------------------------------+"
echo -e "${NC}"

echo -e "${GREEN}Installing Elegant Arch Linux SDDM Theme...${NC}"

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (sudo).${NC}"
  exit 1
fi

# Dependency Installation
install_dependencies() {
    echo "Checking for dependencies..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch|manjaro|endeavouros)
                echo "Detected Arch Linux based distro."
                echo "Ensuring sddm and qt6 dependencies are installed..."
                pacman -S --needed sddm qt6-base qt6-declarative qt6-svg
                ;;
            fedora)
                echo "Detected Fedora."
                echo "Ensuring sddm and qt6 dependencies are installed..."
                dnf install -y sddm qt6-qtbase qt6-qtdeclarative qt6-qtsvg
                ;;
            ubuntu|debian|pop|linuxmint)
                echo "Detected Debian/Ubuntu based distro."
                echo "Ensuring sddm and qt6 dependencies are installed..."
                apt update
                apt install -y sddm qml6-module-qtquick* libqt6svg6
                ;;
            opensuse*|suse)
                echo "Detected openSUSE."
                echo "Ensuring sddm and qt6 dependencies are installed..."
                zypper install -y sddm-qt6 libQt6Svg6 libQt6Quick6
                ;;
            *)
                echo -e "${RED}Unsupported distribution for automatic dependency installation.${NC}"
                echo "Please ensure you have SDDM and Qt6 (qt6-base, qt6-declarative, qt6-svg) installed manually."
                read -p "Press Enter to continue installation..."
        esac
    else
        echo -e "${RED}Cannot detect distribution.${NC}"
        echo "Please ensure you have SDDM and Qt6 installed manually."
    fi
}

install_dependencies

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Cloning repository..."

if git clone "$REPO_URL" "$TEMP_DIR"; then
    if [ -d "$THEME_DIR" ]; then
        echo "Updating existing theme..."
        rm -rf "$THEME_DIR"
    fi

    cp -r "$TEMP_DIR/$THEME_NAME" "$THEME_DIR"
    cp "$TEMP_DIR/$THEME_NAME/customize.sh" "$THEME_DIR/customize.sh"
    chmod +x "$THEME_DIR/customize.sh"

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
    
    if grep -q "BlurStrength=" "$THEME_DIR/theme.conf.user" 2>/dev/null; then
        sed -i "s|^BlurStrength=.*|BlurStrength=$BLUR_VAL|" "$THEME_DIR/theme.conf.user"
    else
        # If theme.conf.user exists, append. If not creating it now.
        if [ ! -f "$THEME_DIR/theme.conf.user" ]; then
             echo "[General]" > "$THEME_DIR/theme.conf.user"
        fi
        echo "BlurStrength=$BLUR_VAL" >> "$THEME_DIR/theme.conf.user"
    fi
    
    read -p "Do you want to activate the theme now? [y/N] " -n 1 -r < /dev/tty
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
        echo "Theme installed but not activated."
        echo "To activate manually, set [Theme] Current=$THEME_NAME in /etc/sddm.conf.d/theme.conf"
    fi

    echo
    echo "Tip: You can customize the theme later by running:"
    echo "sudo $THEME_DIR/customize.sh"
    echo -e "${GREEN}Installation Complete!${NC}"
else
    echo -e "${RED}Failed to clone repository.${NC}"
    exit 1
fi

rm -rf "$TEMP_DIR"
