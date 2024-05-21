#!/bin/bash

echo "Installing flatpak..."
sudo xbps-install flatpak

echo "Installing portproton dependencies..."
echo "Source: https://github.com/Castro-Fidel/PortWINE#dependencies"
sudo xbps-install -Su void-repo-multilib
sudo xbps-install -S bash wget icoutils yad bubblewrap zstd cabextract gzip tar xz openssl desktop-file-utils curl dbus freetype xdg-utils
gdk-pixbuf noto-fonts-ttf nss xrandr lsof mesa-demos ImageMagick Vulkan-Tools libgcc alsa-plugins-32bit libX11-32bit freetype-32bit libglvnd-32bit libgpg-error-32bit nss-32bit openssl-32bit vulkan-loader vulkan-loader-32bit

echo "Adding flathub repository..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installing portproton..."
flatpak install flathub ru.linux_gaming.PortProton
