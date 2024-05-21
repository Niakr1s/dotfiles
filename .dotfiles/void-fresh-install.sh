#!/bin/bash

repo=https://github.com/Niakr1s/dotfiles

echo
echo "Repository: $repo."
echo

echo "This script is intended to configure new, freshly installed void linux system."
echo

echo "Warning: Before running this script, ensure you've run this commands:"
echo "sudo xbps-install yadm"
echo "yadm clone $repo"
echo

echo "Do you wish to continue?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done
echo

echo "Updating system..."
sudo xbps-install -Su
echo

echo "Installing packages..."
sudo xargs -a ~/.dotfiles/void-pkgs.txt xbps-install
echo

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
echo

echo "Adding flathub repository..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo
