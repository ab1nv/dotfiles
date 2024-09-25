#!/bin/bash

is_installed() {
    pacman -Qi $1 &> /dev/null
}

if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay is already installed."
fi

declare -A packages=(
    ["alacritty"]="pacman"
    ["ttf-jetbrains-mono-nerd"]="yay"
    ["google-chrome"]="yay"
    ["spotify"]="yay"
    ["visual-studio-code-bin"]="yay"
    ["zsh-theme-powerlevel10k-git"]="yay"
    ["okular"]="pacman"
    ["spectacle"]="pacman"
    ["vesktop"]="yay"
    ["xclip"]="pacman"
    ["neofetch"]="pacman"
    ["reflector"]="pacman"
    ["apple-fonts"]="yay"
    ["power-profiles-daemon"]="pacman"
    ["ntfs-3g"]="pacman"
    ["flatpak"]="pacman"
    ["timeshift"]="yay"
)

install_package() {
    local package=$1
    local method=$2
    if is_installed $package; then
        echo "$package is already installed."
    else
        if [[ $method == "pacman" ]]; then
            echo "Installing $package with pacman..."
            sudo pacman -S --needed --noconfirm $package
        elif [[ $method == "yay" ]]; then
            echo "Installing $package with yay..."
            yay -S --needed --noconfirm $package
        fi
    fi
}

for package in "${!packages[@]}"; do
    install_package $package ${packages[$package]}
done

echo "All packages have been installed."
