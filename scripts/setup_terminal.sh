#!/bin/bash

if ! command -v alacritty &>/dev/null; then
    echo "Alacritty not found. Installing..."
    sudo pacman -Syu alacritty --noconfirm
else
    echo "Alacritty is already installed."
fi

if ! command -v git &>/dev/null; then
    echo "Git not found. Installing..."
    sudo pacman -Syu git --noconfirm
fi

if ! command -v zsh &>/dev/null; then
    echo "Zsh not found. Installing..."
    sudo pacman -Syu zsh --noconfirm
else
    echo "Zsh is already installed."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
else
    echo "Default shell is already Zsh."
fi

if ! command -v tmux &>/dev/null; then
    echo "Tmux not found. Installing..."
    sudo pacman -Syu tmux --noconfirm
else
    echo "Tmux is already installed."
fi

echo "Terminal setup completed. Dotfiles will be synced later."
