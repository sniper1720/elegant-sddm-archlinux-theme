#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

REPO_URL="https://github.com/sniper1720/elegant-sddm-archlinux-theme.git"
THEME_NAME="elegant-archlinux"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"

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
    
    read -p "Do you want to activate the theme now? [y/N] " -n 1 -r < /dev/tty
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        CONFIG_DIR="/etc/sddm.conf.d"
        CONFIG_FILE="$CONFIG_DIR/elegant-archlinux.conf"
        
        if [ ! -d "$CONFIG_DIR" ]; then
            mkdir -p "$CONFIG_DIR"
        fi

        echo "[Theme]
Current=$THEME_NAME" > "$CONFIG_FILE"
        echo -e "${GREEN}Theme activated!${NC}"
    else
        echo "Theme installed but not activated."
        echo "To activate manually, set [Theme] Current=$THEME_NAME in your sddm config."
    fi

    echo -e "${GREEN}Installation Complete!${NC}"
else
    echo -e "${RED}Failed to clone repository.${NC}"
    exit 1
fi

rm -rf "$TEMP_DIR"
