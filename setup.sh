#!/usr/bin/env bash

# Install script for Sway ricing

# Define source and target directories
SRC_DIR="$(pwd)"
TARGET_DIR="$HOME/.config"
BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"
# List of config directories to symlink
CONFIG_DIRS=("sway" "foot" "alacritty" "waybar")
# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Backup directory created at $BACKUP_DIR"
tar -czf "$BACKUP_DIR/configs_backup.tar.gz" -C "$TARGET_DIR" "${CONFIG_DIRS[@]}"
echo "Existing configurations backed up to $BACKUP_DIR/configs_backup.tar.gz"

# Copy new config from source to target
for dir in "${CONFIG_DIRS[@]}"; do
    SRC_PATH="$SRC_DIR/$dir"
    TARGET_PATH="$TARGET_DIR/$dir"
    if [ -d "$SRC_PATH" ]; then
        # Remove existing config if it exists
        if [ -e "$TARGET_PATH" ] || [ -L "$TARGET_PATH" ]; then
            rm -rf "$TARGET_PATH"
            echo "Removed existing configuration at $TARGET_PATH"
        fi
        # Copy new config
        cp -r "$SRC_PATH" "$TARGET_PATH"
        echo "Copied $SRC_PATH to $TARGET_PATH"
    else
        echo "Source directory $SRC_PATH does not exist. Skipping."
    fi
done


# Install necessary packages
echo "Installing necessary packages..."

# List of pacman packages to install
pacman_packages=(
    "alacritty"
    "dmenu"
    "ttf-nerd-fonts-symbols"
    "ttf-jetbrains-mono-nerd"
)

# Update system and install packages
echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing pacman packages..."
for package in "${pacman_packages[@]}"; do
    echo "Installing $package..."
    sudo pacman -S --noconfirm "$package"
done