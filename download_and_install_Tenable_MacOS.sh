#!/bin/bash

# This script downloads, installs, and optionally updates plugins for the Tenable Nessus Agent.
# Make sure to set these environment variables or modify the defaults before running the script.

# Define URLs and file paths
DMG_URL=${DMG_URL:-"https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.6.4.dmg"}  # Default URL; can be overridden by an environment variable
DMG_LOCATION="/tmp/Nessus-$(basename "$DMG_URL")"
TMP_MOUNT=$(mktemp -d /tmp/nessus_mount.XXXXXX)
PKG_NAME="Install Nessus Agent.pkg"
PLUGINS_SET=${PLUGINS_SET:-"./plugins_set.tgz"}  # Default path; can be overridden by an environment variable

# Function to log messages with timestamps for better readability
log_message() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Function to download the Tenable Nessus Agent DMG file
download_dmg() {
  log_message "Downloading Tenable Nessus Agent DMG..."
  curl --request GET \
       --url "$DMG_URL" \
       --output "$DMG_LOCATION"

  # Check download success and exit if failed
  if [ ! -f "$DMG_LOCATION" ]; then
    log_message "Failed to download Tenable Nessus Agent DMG. Exiting."
    exit 1
  fi
}

# Function to install the Tenable Nessus Agent package
install_package() {
  # Check if the script is run as root
  if [ "$(id -u)" -ne 0 ]; then
    log_message "This script must be run with root privileges. Exiting."
    exit 1
  fi

  # Mount the DMG file
  log_message "Mounting DMG..."
  hdiutil attach -mountpoint "$TMP_MOUNT" "$DMG_LOCATION"

  # Install the Nessus Agent package from the mounted DMG
  log_message "Installing Nessus Agent..."
  sudo installer -pkg "$TMP_MOUNT/$PKG_NAME" -target /

  # Unmount the DMG file
  log_message "Unmounting DMG..."
  hdiutil detach "$TMP_MOUNT"

  # Update plugins set if available _ OPTIONALLY REMOVE IF NOT NEEDED
  if [ -f "$PLUGINS_SET" ]; then
    log_message "Updating Nessus Agent plugins..."
    /opt/nessus_agent/sbin/nessuscli agent update --file="$PLUGINS_SET"
  fi

  # Clean up the temporary mount point
  log_message "Cleaning up temporary directory..."
  rm -rf "$TMP_MOUNT"  # Remove the directory tree recursively

  log_message "Tenable Nessus Agent installation completed. Please follow any additional instructions to complete the setup."
}

# Main script execution
log_message "Starting Tenable Nessus Agent installation..."
download_dmg
install_package
