#!/usr/bin/env bash

# Switch htop theme script

# Define the path to the htop configuration file
HTOP_CONFIG="$HOME/.config/htop/htoprc"
HTOP_CONFIG_BASE="$HOME/.config/htop/htoprc.original"
HTOP_CONFIG_THEME="$HOME/.config/htop/themes/"

# Create a list of themes from the files from the themes directory (assuming they are stored there)
# all files get stripped of htoprc. prefix and .theme suffix
THEMES=()
for file in "$HTOP_CONFIG_THEME"htoprc.*.theme; do
    filename=$(basename "$file")
    theme_name=${filename#htoprc.}
    theme_name=${theme_name%.theme}
    THEMES+=("$theme_name")
done
# Function to display the theme selection menu
display_menu() {
    echo "Select an htop theme:"
    for i in "${!THEMES[@]}"; do
        echo "$((i + 1)). ${THEMES[$i]}"
    done
    echo "q. Quit"
}

# Main loop for theme selection
while true; do
    display_menu
    read -rp "Enter your choice: " choice
    if [[ "$choice" == "q" ]]; then
        echo "Exiting theme switcher."
        break
    elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#THEMES[@]} )); then
        selected_theme="${THEMES[$((choice - 1))]}"

        # Recreate htop config from original base file if it exists
        if [ -f "$HTOP_CONFIG_BASE" ]; then
            cp "$HTOP_CONFIG_BASE" "$HTOP_CONFIG"
            echo "Original htop configuration backed up to $HTOP_CONFIG_BASE"
        fi

        # Append the selected theme to the htop config file
        theme_file="$HTOP_CONFIG_THEME/htoprc.$selected_theme.theme"
        if [ -f "$theme_file" ]; then
            cat "$theme_file" >> "$HTOP_CONFIG"
            echo "Switched to theme: $selected_theme"
        else
            echo "Theme file not found: $theme_file"
        fi
    else
        echo "Invalid choice. Please try again."
    fi
done