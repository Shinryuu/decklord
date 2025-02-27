#!/bin/bash
# Script to fetch latest Bazzite kernel
# and install it for CachyOS.

# Fetch the latest Bazzite Kernel package URL
API_URL="https://api.github.com/repos/hhd-dev/kernel-bazzite/releases/latest"
DOWNLOAD_URL=$(curl -s "$API_URL" | jq -r '.assets[] | select(.name|endswith(".pkg.tar.zst")) | .browser_download_url' | head -n1)
[ -z "$DOWNLOAD_URL" ] && { echo "No .pkg.tar.zst found"; exit 1; }
FILENAME=$(basename "$DOWNLOAD_URL")

# Download and install the kernel package
echo "Downloading $FILENAME..."
curl -L -o "$FILENAME" "$DOWNLOAD_URL"
sudo pacman -U --noconfirm "$FILENAME"
