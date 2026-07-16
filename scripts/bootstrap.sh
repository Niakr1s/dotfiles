#!/usr/bin/env bash

# This script bootstraps new system.
# It installs and configures all packages needed
# If a program needed to be handled manually,
# this script will write a notification.
#
# It depends on $HOSTNAME
# I have 2 computers: desktop and laptop,
# So it will install core system to laptop
# and full system to desktop (including gaming packages)
#
# First, this chezmoi dotfiles repo should be obtained and applied
# sudo zypper install git chezmoi
# git clone <repo> ~/.local/share/chezmoi
# chezmoi apply
# Then logout and login again
#
# And if the access to internet is blocked in Russia
# install and configure vpn client
# sudo zypper install throne

CORE_PKGS=(
  zsh tmux
  git-core chezmoi lazygit
  alacritty yazi
  fd fzf ripgrep zoxide eza bat
  ffmpegthumbnailer chafa resvg
  7zip zip unzip unar unrar lz4 bsdtar
  tealdeer
  neovim python313-neovim
  nautilus
  fira-code-fonts dejavu-fonts xorg-x11-fonts noto-fonts noto-emoji-fonts google-noto-sans-cjk-fonts symbols-only-nerd-fonts
  mpv handbrake-gtk obs-studio
  decibels clementine playerctl
  btm duf gdu scc
  aria2 qbittorrent
  watchexec gnu_parallel lazysql
  fastfetch cmatrix fortune cowsay
  ffmpeg yt-dlp mediainfo audacity kdenlive gpu-screen-recorder-gtk
  gimp inkscape ImageMagick gthumb jp2a
  foliate
  wev wvkbd
  telegram-desktop remmina weechat
  poppler-tools pandoc
  borgbackup
  librecad libreoffice zeal
  blender
  zenity dconf-editor
  kdeconnect-kde
  bluez libnotify-tools
  xdg-user-dirs
  go nodejs
  cargo uv
)

UNNEEDED_PKGS=(
  mako
)

CORE_GO_PKGS=(
  github.com/jorgerojas26/lazysql@latest
)

declare -A CORE_APPIMAGE_PKGS=(
  ["LosslessCut"]="https://github.com/mifi/lossless-cut/releases/download/v3.69.0/LosslessCut-linux-x86_64.AppImage"
  ["Joplin"]="https://github.com/laurent22/joplin/releases/download/v3.6.15/Joplin-3.6.15.AppImage"
  ["MissionCenter"]="https://gitlab.com/mission-center-devs/mission-center/-/jobs/12045090460/artifacts/raw/MissionCenter_v1.1.0-x86_64.AppImage"
)

CORE_PACKMAN_PKGS=(
  ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec
)

install_vpn() {
  if ! which throne; then
    echo "Installing VPN client (throne)..."

    # https://parhelia512.github.io/
    sudo zypper addrepo -fc "https://parhelia512.github.io/throne-sle.repo"
    sudo zypper install -y throne
  else
    echo "VPN client (throne) was found, skipping"
  fi
}

enable_packman_repo() {
  if zypper lr | grep pakman &>/dev/null; then
    echo "Enabling packman repo..."

    # https://en.opensuse.org/SDB:Installing_codecs_from_Packman_repositories#Solution
    sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
    sudo zypper refresh
    sudo zypper dist-upgrade --from packman --allow-vendor-change
  else
    echo "Packman repo already enabled, skipping"
  fi
}

postinstall() {
  echo "Creating user directories..."
  xdg-user-dirs-update --force

  echo "Enabling snapper home snapshots..."
  sudo snapper -c home create-config /home
}

cleanup() {
  echo "Removing unneeded packages..."
  sudo zypper remove -y $UNNEEDED_PKGS
}

# $1 is a associative array in format [AppName]=<url>
install_appimages() {
  APPS=$1
  for app in "${!APPS[@]}"; do
    url="${APPS[$app]}"
    echo "Installing appimage $app..."
    appimage-install "$app" "$url"
  done
}

install_core_packages() {
  echo "Installing core packages from packman repo..."
  sudo zypper install -y --from packman $CORE_PACKMAN_PKGS

  echo "Installing core packages..."
  sudo zypper install -y $CORE_PKGS

  echo "Installing core golang packages..."
  go install $CORE_GO_PKGS

  echo "Installing core appimages..."
  install_appimages $CORE_APPIMAGE_PKGS

  echo "Installing Zed editor..."
  curl -f https://zed.dev/install.sh | sh
}

install_niri_dms() {
  echo "Installing niri and dankmaterialshell...."
  sudo zypper addrepo https://download.opensuse.org/repositories/home:AvengeMedia:danklinux/openSUSE_Tumbleweed/home:AvengeMedia:danklinux.repo
  sudo zypper addrepo https://download.opensuse.org/repositories/home:/AvengeMedia:/dms/openSUSE_Tumbleweed/home:AvengeMedia:dms.repo
  sudo zypper refresh

  sudo zypper install -y dms dms-greeter niri power-profiles-daemon cups-pk-helper xwayland

  dms greeter install
  dms greeter sync

  systemctl --user enable dms
  systemctl --user add-wants niri.service dms
}

enable_virtualization() {
  echo "Enabling virtualizaiton..."
  sudo zypper install -y libvirt virt-manager python3-libguestfs
  sudo usermod -aG libvirt $USER
  sudo systemctl start libvirtd.service
}

enable_docker() {
  echo "Enabling docker..."
  sudo zypper install docker docker-compose docker-compose-switch
  sudo systemctl enable docker
  sudo usermod -G docker -a $USER
  newgrp docker
  sudo systemctl restart docker
}

# --------MAIN--------
install_vpn 

enable_packman_repo
install_core_packages 

install_niri_dms

if [[ $HOSTNAME == "desktop" ]]; then
  enable_virtualization 
  enable_docker
fi

postinstall
cleanup 
