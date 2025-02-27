#!/bin/bash
# Installation script for Ally X,
# Deckified CachyOS. This is for
# a pure OS experience without
# using Bazzite kernel at all.

# Tweaks
# Add "rcutree.enable_rcu_lazy=1" to the /etc/sdboot-manage.conf
# Check /etc/default/scx configuration and make sure to use "LAVD"
# echo kernel.split_lock_mitigate=0 > /etc/sysctl.d/99-splitlock.conf

# Package list
SYSTEM_PACKAGES=(
    acpi_call ark asusctl bluedevil breeze-gtk dolphin firefox kate konsole kpipewire kscreen
    kwayland kwin libkscreen linux-cachyos-deckify linux-cachyos-deckify-headers
    maliit-framework maliit-keyboard mkinitcpio-firmware mpv okular plasma-desktop
    plasma-nm plasma-pa polkit-kde-agent qt-wayland rog-control-center ryzen_smu-dkms-git
    ryzenadj-git sddm sddm-kcm spectacle xdg-desktop-portal-kde
    yakuake yt-dlp
)

# Install packages
paru -S --needed --noconfirm "${SYSTEM_PACKAGES[@]}"

# Install HHD
curl -L https://github.com/hhd-dev/hhd/raw/master/install.sh | bash

# Install Decky Loader
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh

# Remove inputplumber if installed
pacman -Qi inputplumber &>/dev/null && sudo pacman -Rns --noconfirm inputplumber

# Blacklist hid-asus
echo "blacklist hid-asus" | sudo tee /etc/modprobe.d/blacklist.conf > /dev/null

# Deckify the system
pacman -S --needed --noconfirm cachyos-handheld linux-cachyos-deckify linux-cachyos-deckify-headers
