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

# Create directories if they don't exist
mkdir -p "$DEST_DIR" "$BIN_DIR"

# Move the file
mv "$FILE_PATH" "$DEST_DIR/"
echo "Moved $FILE_PATH to $DEST_DIR"

# Extract filename without extension for symlink
FILENAME=$(basename "$FILE_PATH" | sed -e 's/\..*//')
# Create symlink
ln -sf "$DEST_DIR/$FILENAME.appimage" "$BIN_DIR/$APP_NAME"
echo "Created symlink in $BIN_DIR for $APP_NAME"

