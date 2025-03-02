#!/bin/bash

echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "Installing XFCE Desktop..."
sudo apt install xfce4 xfce4-goodies -y

echo "Installing XRDP for Remote Desktop Access..."
sudo apt install xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp

echo "Configuring XRDP to use XFCE..."
echo "startxfce4" | sudo tee /etc/skel/.xsession
sudo systemctl restart xrdp

echo "Allowing RDP port through firewall..."
sudo ufw allow 3389/tcp
sudo ufw enable -y

echo "Creating a new user for RDP login..."
read -p "Enter a new username for RDP: " new_user
sudo adduser $new_user
sudo passwd $new_user

echo "Granting the new user sudo privileges..."
sudo usermod -aG sudo $new_user

echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y

echo "Modifying Chrome launcher to use --no-sandbox..."
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable %U|Exec=/usr/bin/google-chrome-stable --no-sandbox %U|' /usr/share/applications/google-chrome.desktop

echo "Installing GDebi for easy .deb installations..."
sudo apt install gdebi -y

echo "Setting GDebi as default for .deb files..."
xdg-mime default gdebi.desktop application/vnd.debian.binary-package

echo "Restarting XRDP service..."
sudo systemctl restart xrdp

echo "Installation complete! You can now connect via RDP."
echo "Use the following credentials:"
echo "Username: $new_user"
echo "Password: (You set this during installation)"
echo "RDP Address: Use your VPS IP address."
