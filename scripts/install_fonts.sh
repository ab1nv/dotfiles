#!/bin/bash

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
