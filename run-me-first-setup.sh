#!/bin/bash

# Run this script first to setup the appimage helper.

# Variables
repo_root=$(pwd)
appimage_dir="$HOME/.local/share/appimages"
runner_script="appimage-helper.sh"
installer_script="install-appimage.sh"

# Check if in git repository root
if [ ! -d .git ]; then
    echo "Error: Please run this script in the root of the git repository."
    exit 1
fi

# Create AppImage directory
echo "Creating AppImage directory at ${appimage_dir}..."
mkdir -p "$appimage_dir"

# Copy the two scripts to a location in PATH
echo "Installing $runner_script and $installer_script..."
install_path="$HOME/.local/bin"
mkdir -p "$install_path"
cp "$repo_root/$runner_script" "$install_path"
cp "$repo_root/$installer_script" "$install_path"
chmod u+x "$install_path/$runner_script"
chmod u+x "$install_path/$installer_script"

# Add directory to PATH if not already there
if ! echo "$PATH" | grep -q "$install_path"; then
  echo "export PATH=\"$install_path:\$PATH\"" >> "$HOME/.bashrc"
  echo "PATH updated. Please restart your terminal or source .bashrc to apply changes."
fi

echo "Installation complete."
