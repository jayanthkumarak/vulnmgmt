# vulnmgmt
A broad repo for vulnerability management related scripts and tooling

For Script 1 : download_and_install_Tenable_MacOS.sh 

Here is the detailed description:

Tenable Nessus Agent Installation Script for macOS

This Bash script automates the process of downloading, extracting, and installing the Tenable Nessus Agent on macOS systems. It's designed to simplify the deployment of Tenable agents across multiple macOS devices.

Features:
Download DMG: Downloads the Tenable Nessus Agent DMG file from the official Tenable URL.
Mount and Extract: Mounts the DMG file and extracts the necessary installation packages.
Installation: Installs the Nessus Agent using the macOS installer command.
Plugin Update (Optional): Optionally updates the Nessus Agent plugins set if a specific file is provided.
Logging: Provides clear log messages to the console, detailing each step of the installation process.
Usage:
Update the constants at the beginning of the script with the appropriate values for your setup, including the paths to the DMG file and plugin set (if applicable).
Save the script with a .sh extension.
Make the script executable with the command: chmod +x <script_name>.sh.
Run the script with administrative privileges: sudo ./<script_name>.sh.
Requirements:
macOS system with administrative access.
curl must be installed to download the DMG file.
Notes:
This script is intended for use by system administrators and IT professionals familiar with macOS and Bash scripting. Always test the script in a controlled environment before deploying it widely.
