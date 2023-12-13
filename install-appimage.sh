#!/bin/bash
DEST_DIR="$HOME/.local/share/appimages"
BIN_DIR="$HOME/.local/bin"

install_appimage() {
  file_path=$1

  shopt -s nocasematch
  if [[ ! $(basename $1) =~ ^([a-zA-Z]+).*.appimage$ ]]; then
    echo "File does not match expected pattern"
    exit 1
  fi

  # This is the short name of the AppImage
  app_shortname=${BASH_REMATCH[1]}

  # Create directories if they don't exist
  mkdir -p "$DEST_DIR" "$BIN_DIR"

  # Move the file
  mv "$file_path" "$DEST_DIR/"
  echo "Moved '$file_path' to '$DEST_DIR'"

  # Create symlink to helper
  ln -sf "$BIN_DIR/appimage-helper.sh" "$BIN_DIR/$app_shortname"
  echo "Created symlink in '$BIN_DIR' for '$app_shortname'"

}

uninstall_appimage() {
  app_shortname=$1

  rm -f "$DEST_DIR/$APP_NAME.appimage"
  echo "Removed '$DEST_DIR/$APP_NAME.appimage'"

  rm -f "$BIN_DIR/$app_shortname"
  echo "Removed symlink in '$BIN_DIR' for '$app_shortname'"
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
  app_shortname="$2"
  if [[ -e $HOME/.local/bin/$app_shortname ]] ; then
    uninstall_appimage "$app_shortname"
  else
    echo "AppImage with shortname '$app_shortname' not found."
    exit 1
  fi
else
  install_appimage "$1"
fi

