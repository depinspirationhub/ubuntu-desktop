#!/bin/bash

echo "Stopping XRDP service..."
sudo systemctl stop xrdp
sudo systemctl disable xrdp

echo "Removing XRDP..."
sudo apt remove --purge xrdp -y

echo "Removing ALL GUI-related packages (XFCE, Xorg, Chrome, LightDM, etc.)..."
sudo apt remove --purge '*xfce*' '*xorg*' '*lightdm*' '*chrome*' '*gui*' -y

echo "Cleaning up unneeded dependencies..."
sudo apt autoremove -y
sudo apt clean

echo "Disabling GUI startup..."
sudo systemctl set-default multi-user.target

echo "Uninstallation complete! Rebooting to apply changes..."
sudo reboot
