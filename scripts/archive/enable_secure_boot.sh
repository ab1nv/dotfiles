#!/bin/bash

sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --modules="tpm" --disable-shim-lock
sudo update-grub
sudo pacman -S sbctl
sbctl status
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sbctl status

echo "Use sudo sbctl sign -s for each unsigned file."