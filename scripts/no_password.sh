#!/bin/bash

# Function to check if a command exists on the system
is_valid_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Infinite loop to get user input until interrupted (Ctrl+C)
while true; do
    # Ask the user for a command
    read -p "Enter a command to allow without sudo password: " user_command

    # Check if the command exists on the system
    if is_valid_command "$user_command"; then
        echo "$user_command is a valid command."

        # Ask for the user's username
        read -p "Enter your username to update sudoers: " username

        # Backup the sudoers file first
        sudo cp /etc/sudoers /etc/sudoers.bak

        # Modify the sudoers file to allow the command without a password
        sudo bash -c "echo '$username ALL=(ALL) NOPASSWD: $(command -v $user_command)' >> /etc/sudoers"
        echo "Command '$user_command' added to sudoers file without requiring a password."

    else
        echo "$user_command is not a valid command. Please enter a valid Arch Linux command."
    fi

    echo ""
done
