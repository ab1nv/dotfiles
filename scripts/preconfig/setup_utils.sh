#!/bin/bash

install_package() {
    local package=$1
    if ! pacman -Qi "$package" &>/dev/null; then
        echo "Installing $package..."
        yay -S "$package" --noconfirm
    else
        echo "$package is already installed."
    fi
}

install_pacman_package() {
    local package=$1
    if ! pacman -Qi "$package" &>/dev/null; then
        echo "Installing $package via pacman..."
        sudo pacman -S "$package" --noconfirm
    else
        echo "$package is already installed."
    fi
}

echo "Starting installation of required packages..."

install_package htop-git
install_package nvtop-git
install_package vlc-git
install_package go
install_package wireshark-git
install_package copyq
install_package shutter-git

if ! command -v poetry &>/dev/null; then
    echo "Installing Python Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
else
    echo "Python Poetry is already installed."
fi

if ! command -v code &>/dev/null; then
    echo "Installing Visual Studio Code..."
    yay -S visual-studio-code-bin --noconfirm
else
    echo "Visual Studio Code is already installed."
fi

install_pacman_package syncthing
install_package obsidian

echo "All specified tools have been installed."
