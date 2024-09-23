#!/bin/bash

sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --modules="tpm" --disable-shim-lock
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo pacman -S sbctl
sbctl status
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sbctl status

VERIFY_OUTPUT=$(sudo sbctl verify 2>&1)

if [ $? -ne 0 ]; then
    echo "Failed to verify files with sbctl."
    exit 1
fi

UNSIGNED_FILES=$(echo "$VERIFY_OUTPUT" | grep "not signed" | awk '{print $NF}')

if [ -z "$UNSIGNED_FILES" ]; then
    echo "All files are already signed."
    exit 0
fi

for FILE in $UNSIGNED_FILES; do
    if [ -f "$FILE" ]; then
        echo "Signing $FILE..."
        sudo sbctl sign -s "$FILE"
    else
        echo "$FILE does not exist."
    fi
done

sudo sbctl verify
echo "Signing process completed."
