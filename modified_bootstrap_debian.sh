#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
}

# Append 'contrib non-free' to each active deb repository line in sources.list
log "Adding 'contrib non-free' to active lines in sources.list..."
sudo sed -i '/^deb / s/$/ contrib non-free/' /etc/apt/sources.list

# Edit /etc/default/grub for GRUB settings
log "Configuring GRUB settings..."
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/' /etc/default/grub
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/a GRUB_CMDLINE_LINUX="rhgb quiet mitigations=off"' /etc/default/grub

# Update GRUB and initramfs
log "Updating GRUB and initramfs..."
sudo update-grub
sudo update-initramfs -u -k all

# Remove Debian games bloatware and clean up
log "Removing bloatware and cleaning up..."
sudo apt purge -y gnome-games libreoffice* && sudo apt autoremove -y && sudo apt autoclean -y

# Update and upgrade the system
log "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install Golang
log "Installing Golang..."
sudo apt install -y golang-go
mkdir -p $HOME/go

# Install Tomnomnom's tools
log "Installing waybackurls, assetfinder, and httprobe..."
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/httprobe@latest

# Install Metasploit Framework
log "Installing Metasploit Framework..."
sudo apt install -y metasploit-framework

# Install Wireshark
log "Installing Wireshark..."
sudo apt install -y wireshark

# Install BurpSuite
log "Installing BurpSuite..."
sudo apt install -y burpsuite

# Install additional popular pentesting tools
log "Installing additional pentesting tools..."
sudo apt install -y nmap nikto sqlmap hydra john

# Final update and upgrade
log "Final update and upgrade..."
sudo apt update && sudo apt upgrade -y

log "Setup complete."
