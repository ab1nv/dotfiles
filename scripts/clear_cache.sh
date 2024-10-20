#!/bin/bash

sudo pacman -Scc # clear pacman cache
sudo pacman -Rns $(pacman -Qdtq) # clear orphaned packages cache
yay -Yc # Remove Unused Cached Packages
