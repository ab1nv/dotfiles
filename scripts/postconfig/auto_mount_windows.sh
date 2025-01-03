#!/bin/bash

PARTITION="/dev/nvme0n1p4"  # Change this to the correct NTFS partition
MOUNT_POINT="/mnt/windows"

if ! command -v ntfs-3g &> /dev/null; then
    echo "ntfs-3g is not installed. Installing now..."
    sudo pacman -S --noconfirm ntfs-3g
else
    echo "ntfs-3g is already installed."
fi

# Create the mount point if it doesn't exist
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point at $MOUNT_POINT"
    sudo mkdir -p "$MOUNT_POINT"
fi

# Mount the partition
if mount | grep "$MOUNT_POINT" > /dev/null; then
    echo "The partition is already mounted at $MOUNT_POINT."
else
    echo "Mounting $PARTITION to $MOUNT_POINT..."
    sudo mount -t ntfs-3g "$PARTITION" "$MOUNT_POINT"

    if [ $? -eq 0 ]; then
        echo "Successfully mounted $PARTITION to $MOUNT_POINT."
    else
        echo "Failed to mount $PARTITION."
    fi
fi
