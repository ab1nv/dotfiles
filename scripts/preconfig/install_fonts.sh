#!/bin/bash

yay -Syu --noconfirm

# Install the fonts
echo "Installing fonts..."
yay -S --noconfirm ttf-jetbrains-mono ttf-jetbrains-mono-nerd inter-font noto-fonts-cjk wqy-zenhei

echo "Fonts installed successfully."
