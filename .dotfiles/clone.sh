#!/bin/bash

repo=https://github.com/Niakr1s/dotfiles

confirm_exit_if_no()
{
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No ) exit;;
        esac
    done
}

echo "This script will clone repository and probably override your files."
echo "Are you sure you want to do this?"
confirm_exit_if_no

sudo xbps-install yadm
yadm clone $repo
yadm checkout ~
