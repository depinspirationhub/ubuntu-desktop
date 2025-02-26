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

echo "Uninstalling Snap and Flatpak applications..."
# Remove all Snap apps including Hivello
sudo snap remove --purge $(snap list | awk 'NR>1 {print $1}')
sudo apt remove --purge snapd -y
sudo rm -rf ~/snap /var/cache/snapd /var/lib/snapd

# Remove all Flatpak apps
flatpak uninstall --delete-data -y --noninteractive
sudo apt remove --purge flatpak -y
sudo rm -rf ~/.var/app /var/lib/flatpak

echo "Cleaning up unneeded dependencies..."
sudo apt autoremove -y
sudo apt clean

echo "Removing all non-root users..."
for user in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd); do
    if [[ "$user" != "root" ]]; then
        echo "Deleting user: $user"
        sudo deluser --remove-home $user
    fi
done

echo "Resetting system settings..."
sudo rm -rf /etc/skel/.config /etc/skel/.local /home/*/.config /home/*/.local

echo "Disabling GUI startup..."
sudo systemctl set-default multi-user.target

echo "Final cleanup before reboot..."
sudo rm -rf /tmp/* /var/tmp/*

echo "Uninstallation complete! Rebooting to apply changes..."
sudo reboot
