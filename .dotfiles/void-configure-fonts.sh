#!/bin/bash

# This script is used to configure fonts.

# removing applied
echo "- /etc/fonts/conf.d/10-hinting-slight.conf: Set hintslight to hintstyle"
rm /etc/fonts/conf.d/10-hinting-slight.conf
echo "- /etc/fonts/conf.d/10-scale-bitmap-fonts.conf: Bitmap scaling"
rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf
echo "- /etc/fonts/conf.d/10-sub-pixel-none.conf: Disable sub-pixel rendering"
rm /etc/fonts/conf.d/10-sub-pixel-none.conf
echo "- /etc/fonts/conf.d/20-unhint-small-dejavu-sans-mono.conf: No description"
rm /etc/fonts/conf.d/20-unhint-small-dejavu-sans-mono.conf
echo "- /etc/fonts/conf.d/20-unhint-small-dejavu-sans.conf: No description"
rm /etc/fonts/conf.d/20-unhint-small-dejavu-sans.conf
echo "- /etc/fonts/conf.d/20-unhint-small-dejavu-serif.conf: No description"
rm /etc/fonts/conf.d/20-unhint-small-dejavu-serif.conf
echo "- /etc/fonts/conf.d/20-unhint-small-vera.conf: Disable hinting for Bitstream Vera fonts when the size is less than 8ppem"
rm /etc/fonts/conf.d/20-unhint-small-vera.conf

# adding new
echo "+ /usr/share/fontconfig/conf.avail/09-autohint-if-no-hinting.conf: Enable autohinter if font doesn't have any hinting"
ln -s /usr/share/fontconfig/conf.avail/09-autohint-if-no-hinting.conf /etc/fonts/conf.d/
echo "+ /usr/share/fontconfig/conf.avail/10-autohint.conf: Enable autohinter"
ln -s /usr/share/fontconfig/conf.avail/10-autohint.conf /etc/fonts/conf.d/
echo "+ /usr/share/fontconfig/conf.avail/10-hinting-full.conf: Set hintfull to hintstyle"
ln -s /usr/share/fontconfig/conf.avail/10-hinting-full.conf /etc/fonts/conf.d/
echo "+ /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf: Enable sub-pixel rendering with the RGB stripes layout"
ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
echo "+ /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf: Reject bitmap fonts"
ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

echo
echo "Reconfigirung..."
xbps-reconfigure -f fontconfig
echo

echo "Results:"
fc-conflist
