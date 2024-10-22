#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Define the Timeshift backup directory
TIMESHIFT_DIR="/timeshift/snapshots"

# Check if Timeshift directory exists
if [ ! -d "$TIMESHIFT_DIR" ]; then
  echo "Timeshift directory not found: $TIMESHIFT_DIR"
  exit 1
fi

# Function to add a new entry to GRUB
add_grub_entry() {
  local snapshot_dir="$1"
  local snapshot_name=$(basename "$snapshot_dir")
  local grub_entry="menuentry 'Ubuntu (Timeshift - $snapshot_name)' {\n\tset root=(hd0,gpt1)\n\tlinux /$snapshot_name/boot/vmlinuz-$(uname -r) root=/dev/sda1 ro quiet splash\n\tinitrd /$snapshot_name/boot/initrd.img-$(uname -r)\n}"

  # Append the new entry to /etc/grub.d/40_custom
  echo -e "$grub_entry" >> /etc/grub.d/40_custom
}

# Loop through all Timeshift snapshots and add them to GRUB
for snapshot_dir in "$TIMESHIFT_DIR"/*; do
  if [ -d "$snapshot_dir" ]; then
    add_grub_entry "$snapshot_dir"
  fi
done

# Update GRUB
update-grub

echo "Timeshift backups have been added to the GRUB menu."
