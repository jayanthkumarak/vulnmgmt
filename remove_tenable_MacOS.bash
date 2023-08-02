#!/bin/bash

# Function to log messages
log_message() {
  echo "$1"
}

# Function to uninstall the Tenable Nessus Agent
uninstall_tenable_agent() {
  # Check if the script is run as root
  if [ "$(id -u)" -ne 0 ]; then
    log_message "This script must be run as root. Exiting."
    exit 1
  fi

  # Remove Tenable Nessus directories
  log_message "Removing Tenable Nessus directories..."
  sudo rm -rf /Library/NessusAgent
  sudo rm /Library/LaunchDaemons/com.tenablesecurity.nessusagent.plist
  sudo rm -r "/Library/PreferencePanes/Nessus Agent Preferences.prefPane"

  # Disable the Nessus Agent service
  log_message "Disabling the Nessus Agent service..."
  sudo launchctl remove com.tenablesecurity.nessusagent

  log_message "Tenable Nessus Agent uninstalled successfully."
}

# Main execution starts here
log_message "Starting Tenable Nessus Agent uninstallation."
uninstall_tenable_agent
