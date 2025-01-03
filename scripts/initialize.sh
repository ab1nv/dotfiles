#!/bin/bash

# install yay

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# setup dual boot

install_package() {
    local package=$1
    if ! pacman -Qi "$package" &>/dev/null; then
        echo "Installing $package..."
        sudo pacman -S "$package" --noconfirm
    else
        echo "$package is already installed."
    fi
}

install_package os-prober
sudo cp /etc/default/grub /etc/default/grub.bak
echo "Modifying /etc/default/grub..."
sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
echo "Updating GRUB configuration..."
sudo update-grub
echo "OS Prober installed, GRUB configuration updated, and GRUB menu regenerated."

# setup dotfiles

echo "Installing the latest Python version..."
sudo pacman -Syu python --noconfirm
echo "Cloning ab1nv/dotfiles into the home directory..."
cd ~
git clone https://github.com/ab1nv/dotfiles.git
cd dotfiles
echo "Running dawt.py..."
python dawt.py
echo "Installation and setup complete."

# setup git with verified commits

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
echo "Checking for existing GPG keys..."
gpg_key=$(gpg --list-secret-keys --keyid-format LONG "$git_email" 2>/dev/null | grep "sec" | awk '{print $2}' | cut -d'/' -f2)
if [[ -z "$gpg_key" ]]; then
    echo "No GPG key found for $git_email. Generating a new GPG key..."
    gpg --full-generate-key
    echo "Listing available GPG keys..."
    gpg --list-secret-keys --keyid-format LONG
    read -p "Enter the GPG key ID you want to use for signing commits: " gpg_key
    echo "Uploading GPG key to GitHub..."
    gpg --armor --export "$gpg_key" | gh gpg-key add -
    echo "GPG key has been added to your GitHub account."
fi
git config --global user.signingkey "$gpg_key"
git config --global commit.gpgSign true
echo "To test GPG commit signing, make a test commit with:"
echo "git commit -m 'Test commit' --gpg-sign"
echo "You can verify this commit with: git log --show-signature"
echo "Git setup complete, including commit signature verification."

# setup fonts

is_installed() {
    pacman -Qi "$1" &> /dev/null
}

install_jetbrains_mono() {
    echo "Installing JetBrains Mono..."
    if is_installed ttf-jetbrains-mono; then
        echo "JetBrains Mono is already installed."
    else
        sudo pacman -S --noconfirm ttf-jetbrains-mono
        echo "JetBrains Mono installed successfully."
    fi
}

install_jetbrains_nerd() {
    echo "Installing JetBrains Mono Nerd Font..."
    if is_installed nerd-fonts-jetbrains-mono; then
        echo "JetBrains Mono Nerd Font is already installed."
    else
        yay -S --noconfirm ttf-jetbrains-mono-nerd
        echo "JetBrains Mono Nerd Font installed successfully."
    fi
}

install_inter_font() {
    echo "Installing Inter Font..."
    if is_installed inter-font; then
        echo "Inter Font is already installed."
    else
        yay -S --noconfirm inter-font
        echo "Inter Font installed successfully."
    fi
}

install_other_fonts() {
    echo "Installing Japanese, Korean and Chinese fonts..."
    yay -S --noconfirm noto-fonts-cjk wqy-zenhei
    echo "Japanese, Korean and Chinese fonts installed successfully."
}

install_fonts() {
    install_jetbrains_mono
    install_jetbrains_nerd
    install_inter_font
    install_other_fonts
    echo "All fonts installed successfully."
}

install_fonts
sudo fc-cache -fv

# setup mouse, display, resolution, cursor
# create recycle bin directory
# setup grub theme