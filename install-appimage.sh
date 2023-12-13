#!/bin/bash
APPIMAGE_DIR="$HOME/.local/share/appimages"
BIN_DIR="$HOME/.local/bin"

tmpfile=$(mktemp)
trap 'rm -f $tmpfile' 0

install_appimage() {
  file_path=$1

  shopt -s nocasematch
  if [[ ! $(basename "$1") =~ ^([a-zA-Z0-9]+).*.appimage$ ]]; then
    echo "File does not match expected pattern"
    exit 1
  fi

  # This is the short name of the AppImage
  app_shortname=${BASH_REMATCH[1]}

  # Move the AppImage
  mkdir -p "$APPIMAGE_DIR" "$BIN_DIR"
  mv "$file_path" "$APPIMAGE_DIR/"
  echo "Moved '$file_path' to '$APPIMAGE_DIR'"

  # Create symlink to shortname
  ln -sf "$BIN_DIR/appimage-helper.sh" "$BIN_DIR/$app_shortname"
  echo "Created symlink in '$BIN_DIR' for '$app_shortname'"

}

uninstall_appimage() {
  app_shortname=$1

  # initial version: delete all versions of the appimage
  files=$(find "$APPIMAGE_DIR" -type f -iname "${app_shortname}*.appimage")

  if [[ ! $files ]]; then
    echo "No AppImage with shortname '$app_shortname' exists."
    exit 1
  fi

  for appimage in $files ; do
    echo rm -f "$APPIMAGE_DIR/$appimage"
    echo "Removed '$APPIMAGE_DIR/$appimage'"
  done
  echo rm -f "$BIN_DIR/$app_shortname"
  echo "Removed symlink in '$BIN_DIR' for '$app_shortname'"
}

list_appimages() {
  for shortname in $(find "$BIN_DIR" -lname '*appimage-helper.sh' -type l -exec basename {} \;) ; do
    appimage=$(ls $APPIMAGE_DIR | grep -i $shortname | sort -V | tail -1)
    echo "${shortname} -> ${appimage}" >> $tmpfile
  done
  column -t $tmpfile
  
}

# Main script
if [ "$#" -lt 1 ]; then
  ME=$(basename "$0")
  cat<<-EOF
	Usage:
      List all appimages     $ME -l
	  Install an appimage:   $ME <path-to-appimage>
	  Uninstall an appimage: $ME -u <appimage-shortname>
	EOF
  exit 1
fi

if [ "$1" == "-u" ] ; then
  app_shortname="$2"
  if [[ -e $HOME/.local/bin/$app_shortname ]] ; then
    uninstall_appimage "$app_shortname"
  else
    echo "AppImage with shortname '$app_shortname' not found."
    exit 1
  fi
elif [ "$1" == "-l" ] ; then
  list_appimages
else
  install_appimage "$1"
fi

