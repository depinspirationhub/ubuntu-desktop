#!/bin/bash

echo "Stopping XRDP service..."
sudo systemctl stop xrdp
sudo systemctl disable xrdp

echo "Removing XRDP..."
sudo apt remove --purge xrdp -y

echo "Removing ALL GUI-related packages (XFCE, Xorg, Chrome, LightDM, etc.)..."
sudo apt remove --purge '*xfce*' '*xorg*' '*lightdm*' '*chrome*' '*gui*' -y

echo "Removing manually installed GUI applications..."
sudo apt remove --purge '*gnome*' '*kde*' '*lxde*' '*mate*' '*i3*' '*wayland*' '*hivello*' -y

echo "Removing flatpak and snap packages..."
sudo snap list | awk 'NR>1 {print $1}' | xargs -I {} sudo snap remove {}
flatpak uninstall --delete-data -y --noninteractive

echo "Cleaning up unneeded dependencies..."
sudo apt autoremove -y
sudo apt clean

echo "Disabling GUI startup..."
sudo systemctl set-default multi-user.target

echo "Removing the RDP user..."
read -p "Enter the username you created for RDP: " rdp_user
sudo deluser --remove-home $rdp_user
echo "User $rdp_user has been removed."

echo "Uninstallation complete! Rebooting to apply changes..."
sudo reboot
