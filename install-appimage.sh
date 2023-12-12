#!/bin/bash

# Enable case-insensitive matching
shopt -s nocasematch

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-appimage>"
    exit 1
fi

FILE_PATH=$1
DEST_DIR="$HOME/.local/share/appimages"
BIN_DIR="$HOME/.local/bin"

if [[ ! $(basename $1) =~ ^([a-zA-Z]+).*.appimage$ ]]; then
    echo "File does not match expected pattern"
    exit 1
fi

APP_NAME=${BASH_REMATCH[1]}
echo $APP_NAME

# Create directories if they don't exist
mkdir -p "$DEST_DIR" "$BIN_DIR"

# Move the file
mv "$FILE_PATH" "$DEST_DIR/"
echo "Moved $FILE_PATH to $DEST_DIR"


# Create symlink to helper
ln -sf "$BIN_DIR/appimage-helper.sh" "$BIN_DIR/$APP_NAME"
echo "Created symlink in $BIN_DIR for $APP_NAME"

