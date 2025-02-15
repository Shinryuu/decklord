#!/bin/bash

# Dirty script to fetch latest release for
# Bazzite kernel. Be sure to install tools
# 'rog-control-center', 'asusctl', 'decky-loader'
# before running this script. Intended to be used
# on Rog Ally X + CachyOS setup.

### Step 1: Fetch the Bazzite Kernel

# GitHub API URL for latest release
API_URL="https://api.github.com/repos/hhd-dev/kernel-bazzite/releases/latest"

# Fetch latest release data and extract the correct download URL
DOWNLOAD_URL=$(curl -s "$API_URL" | jq -r '.assets[] | select(.name | endswith(".pkg.tar.zst")) | .browser_download_url' | head -n 1)

# Exit if no valid package is found
[[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]] && { echo "No .pkg.tar.zst package found"; exit 1; }

# Extract filename
FILENAME=$(basename "$DOWNLOAD_URL")

# Download the package
echo "Downloading: $FILENAME"
curl -L -o "$FILENAME" "$DOWNLOAD_URL" || { echo "Download failed"; exit 1; }

# Install package using pacman
echo "Installing: $FILENAME"
sudo pacman -U --noconfirm "$FILENAME" || { echo "Installation failed"; exit 1; }

### Step 2: Run additional setup command
curl -L https://github.com/hhd-dev/hhd/raw/master/install.sh | bash

### Step 3: Update the existing override.conf and variables

CONFIG_FILE="/usr/lib/systemd/system/hhd@.service.d/override.conf"

echo "[Service]
Environment=\"HHD_PPD_MASK=1\"
Environment=\"HHD_ALLY_POWERSAVE=1\"
Environment=\"HHD_HORI_STEAM=1\"" | sudo tee $CONFIG_FILE

### Step 4: Reload systemd manager configuration
sudo systemctl daemon-reload

echo "Done!"
