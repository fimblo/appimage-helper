#!/bin/bash

app_short_name=$(basename $0)
if [[ "$app_short_name" == 'appimage-helper.sh' ]] ; then
  cat<<-EOF
	This script is not meant to run directly as 'appimage-helper.sh'.
	Instead, install the appimage using the 'install-appimage.sh' script,
	then call the appimage by its short name (everything before the first
	hyphen in the filename).
	EOF
  exit 0
fi

appimage_dir="$HOME/.local/share/appimages"
appimage=$(
  find $appimage_dir \
       -type f \
       -name "${app_short_name}-*.AppImage" |\
    sort -V |\
    tail -1)

if [[ ! -e $appimage ]] ; then
  cat<<-EOF
	No AppImage with name starting with '${app_short_name}' was found in
	directory: ${appimage_dir}
	EOF
fi

if [[ ! -x $appimage ]] ; then
  cat<<-EOF
	The AppImage: '${appimage}' is not executable.
	Set exec bit? [y/n]
	EOF
  read -r set_exec_bit
  if [[ ! "$set_exec_bit" == 'y' ]] ; then
    echo "Exiting."
    exit 1
  fi
  echo "Setting exec bit."
  chmod u+x ${appimage}
fi


echo "Running $appimage"
exec ${appimage} > /dev/null 2>&1 &
