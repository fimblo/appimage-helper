#!/bin/bash
DEST_DIR="$HOME/.local/share/appimages"
BIN_DIR="$HOME/.local/bin"

install_appimage() {
  FILE_PATH=$1

  shopt -s nocasematch
  if [[ ! $(basename $1) =~ ^([a-zA-Z]+).*.appimage$ ]]; then
    echo "File does not match expected pattern"
    exit 1
  fi

  # This is the short name of the AppImage
  APP_NAME=${BASH_REMATCH[1]}

  # Create directories if they don't exist
  mkdir -p "$DEST_DIR" "$BIN_DIR"

  # Move the file
  mv "$FILE_PATH" "$DEST_DIR/"
  echo "Moved $FILE_PATH to $DEST_DIR"

  # Create symlink to helper
  ln -sf "$BIN_DIR/appimage-helper.sh" "$BIN_DIR/$APP_NAME"
  echo "Created symlink in $BIN_DIR for $APP_NAME"

}

uninstall_appimage() {
  APP_NAME=$1

  rm -f "$DEST_DIR/$APP_NAME.appimage"
  echo "Removed $DEST_DIR/$APP_NAME.appimage"

  rm -f "$BIN_DIR/$APP_NAME"
  echo "Removed symlink in $BIN_DIR for $APP_NAME"
}



# Main script
if [ "$#" -lt 1 ]; then
  ME=$(basename $0)
  cat<<-EOF
	Usage:
	  Install an appimage:   $ME <path-to-appimage>
	  Uninstall an appimage: $ME -u <appimage-shortname>
	EOF
  exit 1
fi

if [ "$1" == "-u" ]; then
  APP_NAME="$2"
  if [[ -e $HOME/.local/bin/$APP_NAME ]] ; then
    uninstall_appimage "$APP_NAME"
  else
    echo "AppImage with shortname '$APP_NAME' not found."
    exit 1
  fi
else
  install_appimage "$1"
fi

