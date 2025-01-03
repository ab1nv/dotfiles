#!/bin/bash

is_valid_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Default list of commands to make password-free
commands=("pacman" "yay" "mount" "reboot" "systemctl" "ssh")

# Check if arguments are provided
if [ "$#" -gt 0 ]; then
    commands=("$@")
fi

read -p "Enter your username to update sudoers: " username
sudo cp /etc/sudoers /etc/sudoers.bak

for user_command in "${commands[@]}"; do
    if is_valid_command "$user_command"; then
        echo "$user_command is a valid command."

        # Add the command to the sudoers file
        sudo bash -c "echo '$username ALL=(ALL) NOPASSWD: $(command -v $user_command)' >> /etc/sudoers"
        echo "Command '$user_command' added to sudoers file without requiring a password."
    else
        echo "$user_command is not a valid command. Skipping."
    fi
    echo ""
done

echo "All valid commands have been processed."