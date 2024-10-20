#!/bin/bash

if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing git..."
    sudo pacman -S --needed --noconfirm git
else
    echo "Git is already installed."
fi

read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"

echo "Git username and email have been set."

ssh_dir="$HOME/.ssh"
key_file="$ssh_dir/id_rsa"

if [[ -f "$key_file" ]]; then
    echo "SSH key already exists."
else
    echo "Generating a new SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$git_email" -f "$key_file" -N ""
    echo "SSH key generated."
fi

eval "$(ssh-agent -s)"
ssh-add "$key_file"
echo "SSH key added to SSH agent."

echo "Here is your public SSH key:"
cat "$key_file.pub"
echo "Copy the above SSH key to your Git hosting provider (e.g., GitHub, GitLab, etc.)."

read -p "Do you want to upload your SSH key to GitHub automatically (yes/no)? " upload_ssh
if [[ "$upload_ssh" == "yes" ]]; then
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) is not installed. Installing it now..."
        sudo pacman -S --needed --noconfirm github-cli
    fi

    echo "Logging into GitHub..."
    gh auth login

    echo "Uploading SSH key to GitHub..."
    ssh_key_title="$(hostname) SSH Key"
    gh ssh-key add "$key_file.pub" --title "$ssh_key_title"
    echo "SSH key has been added to your GitHub account."
fi

echo "Git setup complete."