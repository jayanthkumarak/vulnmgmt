#!/bin/bash

# Declaring URLs and file paths for downloading, saving, and extracting the Tenable Agent DMG file
DMG_URL="https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.5.4.dmg"
DMG_LOCATION="/tmp/Nessus-10.5.4.dmg"
TMP_MOUNT="/tmp/nessus_mount"
PKG_NAME="Install Nessus Agent.pkg"
PLUGINS_SET="./plugins_set.tgz" # Replace with the actual path to the plugins set, if available

# Function to log messages to the console
log_message() {
  echo "$1"
}

# Function to download the Tenable DMG file from the specified URL
download_dmg() {
  log_message "Downloading Tenable DMG file..."
  curl --request GET \
    --url "$DMG_URL" \
    --output "$DMG_LOCATION"
  
  if [ ! -f $DMG_LOCATION ]; then
    log_message "Failed to download Tenable DMG file. Exiting."
    exit 1
  fi
}

# Function to install the Tenable package from the downloaded DMG file
install_package() {
  # Check if the script is run as root
  if [ "$(id -u)" -ne 0 ]; then
    log_message "This script must be run as root. Exiting."
    exit 1
  fi

  # Mount the DMG file to access its contents
  hdiutil attach -mountpoint $TMP_MOUNT $DMG_LOCATION

  # Install the Nessus Agent from the mounted DMG
  sudo installer -pkg "$TMP_MOUNT/$PKG_NAME" -target /

  # Unmount the DMG file after installation
  hdiutil detach "$TMP_MOUNT"

  # Update plugins set if available
  if [ -f $PLUGINS_SET ]; then
    /opt/nessus_agent/sbin/nessuscli agent update --file=$PLUGINS_SET
  fi

  log_message "Tenable installation completed. Please follow any additional instructions to complete the setup."
}

# Main execution starts here
log_message "Starting Tenable installation."
download_dmg # Download the DMG file
install_package # Extract and install the Tenable package
