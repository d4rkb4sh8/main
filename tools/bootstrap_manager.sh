#!/bin/bash

set -e  # Exit immediately on error

SNAPSHOT_ROOT="/var/backups/debian_snapshots"
SNAPSHOT_DIRS=("/" "/boot" "/etc" "/usr" "/var" "/home")

# Display usage instructions
usage() {
    echo "Usage: $0 [COMMAND]"
    echo
    echo "Commands:"
    echo "  init               Initialize the system with configurations"
    echo "  snapshot           Create a bootable snapshot of the system"
    echo "  rollback           Restore from a snapshot (reboot required)"
    echo "  reapply            Reapply all configurations for consistency"
    echo "  help               Display this help message"
}

# Initialize configurations for packages and settings
init_system() {
    echo "Initializing system configurations..."
    # Package installation and other setup commands here
}

# Create a bootable snapshot for GRUB
create_snapshot() {
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    SNAPSHOT_PATH="${SNAPSHOT_ROOT}/${TIMESTAMP}"
    echo "Creating snapshot at ${SNAPSHOT_PATH}..."
    sudo mkdir -p "${SNAPSHOT_PATH}"

    # Compress each key directory for full system backup
    for dir in "${SNAPSHOT_DIRS[@]}"; do
        sudo tar -cpzf "${SNAPSHOT_PATH}/$(basename "$dir").tar.gz" "$dir"
    done

    echo "Snapshot created: ${SNAPSHOT_PATH}"

    # Update GRUB to add an entry for this snapshot
    add_grub_entry "$SNAPSHOT_PATH" "$TIMESTAMP"
}

# Add a custom GRUB entry for bootable snapshot
add_grub_entry() {
    SNAPSHOT_PATH=$1
    TIMESTAMP=$2

    GRUB_CFG_PATH="/etc/grub.d/40_custom"
    echo "Adding custom GRUB entry for snapshot at ${TIMESTAMP}..."
    
    sudo bash -c "cat >> ${GRUB_CFG_PATH}" <<EOF

menuentry "Restore Snapshot (${TIMESTAMP})" {
    insmod ext2
    set root=(hd0,1)
    linux /vmlinuz root=${SNAPSHOT_PATH}/
    initrd /initrd.img
}
EOF

    # Update GRUB configuration
    sudo update-grub
    echo "GRUB entry for snapshot at ${TIMESTAMP} added."
}

# Rollback using the latest snapshot
rollback() {
    LAST_SNAPSHOT=$(ls -td "${SNAPSHOT_ROOT}"/* | head -n 1)

    if [ -z "${LAST_SNAPSHOT}" ]; then
        echo "Error: No snapshots available for rollback."
        exit 1
    fi

    echo "Restoring from snapshot at ${LAST_SNAPSHOT}..."

    # Unpack the snapshot back to the root directories
    for tarball in "${LAST_SNAPSHOT}"/*.tar.gz; do
        dir=$(basename "$tarball" .tar.gz)
        sudo tar -xpf "$tarball" -C "/$dir"
    done

    echo "Rollback completed. Please reboot to finalize restoration."
}

# Reapply configurations for declarative setup
reapply_configurations() {
    echo "Reapplying configurations..."
    # Commands to reapply system configurations
}

# Git version control for /etc configurations
version_control_setup() {
    if [ ! -d "/etc/.git" ]; then
        sudo git init /etc
        sudo git -C /etc add .
        sudo git -C /etc commit -m "Initial commit of /etc configurations"
    else
        echo "/etc already under version control."
    fi
}

# Main command switch
case "$1" in
    init) init_system ;;
    snapshot) create_snapshot ;;
    rollback) rollback ;;
    reapply) reapply_configurations ;;
    help) usage ;;
    *) echo "Unknown command: $1"; usage; exit 1 ;;
esac
