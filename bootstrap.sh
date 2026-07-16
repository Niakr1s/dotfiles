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

# These packages will be uninstalled in the end
UNNEEDED_PKGS=(
  mako
)

# These packages will be installed for all hosts
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

# These go packages will be installed for all hosts
CORE_GO_PKGS=(
  github.com/jorgerojas26/lazysql@latest
)

# These appimages will be installed for all users
declare -A CORE_APPIMAGE_PKGS=(
  ["LosslessCut"]="https://github.com/mifi/lossless-cut/releases/download/v3.69.0/LosslessCut-linux-x86_64.AppImage"
  ["Joplin"]="https://github.com/laurent22/joplin/releases/download/v3.6.15/Joplin-3.6.15.AppImage"
  ["MissionCenter"]="https://gitlab.com/mission-center-devs/mission-center/-/jobs/12045090460/artifacts/raw/MissionCenter_v1.1.0-x86_64.AppImage"
)

# These packages from packman repository will be installed for all hosts
CORE_PACKMAN_PKGS=(
  ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec
)

# Installs vpn application
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

# Enables packman repo with non-free packages
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

create_user_directories() {
  echo "Creating user directories..."
  xdg-user-dirs-update --force
}

enable_snapper_home_snapshots() {
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

enable_flatpak() {
  echo "Installing flatpak and flatseal..."
  sudo zypper install -y flatpak flatseal
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak update
}

configure_tmux() {
  echo "Installing tmux plugin manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "TPM installed. Use prefix+I to install new plugins and prefix+U to update them"
}

install_syncthing() {
  echo "Installing syncthing..."
  sudo zypper install syncthing
  systemctl --user enable --now syncthing
  echo "Syncthing installed. Proceed to https://127.0.0.1:8384 to configure"
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

install_nvidia_drivers() {
  echo "Installing NVIDIA drivers..."
  sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
  sudo zypper addrepo --refresh https://developer.download.nvidia.com/compute/cuda/repos/suse16/x86_64/ cuda
  sudo zypper refresh
  # G07 is for all new RTX cards
  sudo zypper install -y nvidia-open-driver-G07-signed-kmp-meta
}

install_switch_emulators() {
  echo "Installing Ryujinx..."
  appimage-install Ryujinx "https://git.ryujinx.app/projects/Ryubing/releases/download/1.3.3/ryujinx-1.3.3-x64.AppImage"
  echo "Downloading and install keys..."
  wget -O- "https://archive.org/download/20.0.1-keys/20.0.1 Keys.zip" | bsdtar -xf- -C "$HOME/.config/Ryujinx/system"
  echo "Downloading and installing cheats..."
  mkdir -p $HOME/.config/Ryujinx/mods
  wget -O- "https://github.com/HamletDuFromage/switch-cheats-db/releases/download/2026-04-18/contents_complete.zip" | bsdtar -xf- -C "$HOME/.config/Ryujinx/mods"

  appimage-install eden https://stable.eden-emu.dev/v0.2.1/Eden-Linux-v0.2.1-amd64-clang-pgo.AppImage
  echo "Downloading and install keys..."
  wget -O- "https://archive.org/download/20.0.1-keys/20.0.1 Keys.zip" | bsdtar -xf- -C "$HOME/.local/share/eden/keys"


  local SWITCH_FIRMWARE_PATH="$HOME/Downloads/SwitchFirmware.20.0.1"
  if [[ ! -z "SWITCH_FIRMWARE_PATH" ]]; then
    echo "Downloading firmware to ~/Downloads..."
    wget -O "~/Downloads/SwitchFirmware.20.0.1" "https://github.com/THZoria/NX_Firmware/releases/download/20.0.1/Firmware.20.0.1.zip"
  fi
  echo "Switch firmware is at $SWITCH_FIRMWARE_PATH, don't forget to install it"
}

install_playstation_emulators() {
  echo "Installing pcsx2"
  sudo zypper -y install pcsx2

  echo "Installing bioses..."
  for region in a e j h; do wget -O- "https://github.com/archtaurus/RetroPieBIOS/raw/refs/heads/master/BIOS/pcsx2/bios/ps2-0230${region}-20080220.bin" > "/home/nea/.config/PCSX2/bios/ps2-0230${region}-20080220.bin"; done

  echo "Installing rpcs3"
  sudo zypper -y install rpcs3

  local PCS3_FIRMWARE_PATH="$HOME/Downloads/PS3UPDAT.PUP"
  echo "Downloading PS3 firmware to $PCS3_FIRMWARE_PATH"
  wget -P "$PCS3_FIRMWARE_PATH" "http://dus01.ps3.update.playstation.net/update/ps3/image/us/2026_0318_a2b60b6ac1d2e49e230144345616927c/PS3UPDAT.PUP"
  echo "PS3 firmware is at $SWITCH_FIRMWARE_PATH, don't forget to install it"

  echo "Installing ps3dec (tool for decrypting ps3 iso)..."
  cargo install --git https://github.com/Redrrx/ps3dec

  echo "Installing shadPS4..."
  appimage-install shadPS4 https://github.com/shadps4-emu/shadps4-qtlauncher/releases/download/v224/shadPS4QtLauncher-linux-qt-v224.zip
}

install_microsoft_emulators() {
  echo "Installing xemu..."
  https://github.com/xemu-project/xemu/releases/download/v0.8.136/xemu-0.8.136-x86_64.AppImage
  wget -O- "https://archive.org/download/xemustarter/XEMU FILES.zip" | bsdtar -xf- -C "$HOME/.local/share/xemu"
  echo "Needed xemu fiiles are under $HOME/.local/share/xemu, provide it to emulator them manually"
}

install_gaming_software() {
  echo "Installing steam..."
  sudo zypper install -y steam

  echo "Installing lutris..."
  sudo zypper install -y wine-staging-wow64 winetricks lutris mangohud gamescope mangoapp

  echo "Installing retroarch..."
  echo "Refer to docs/retroarch.md for further configuration"
  sudo zypper install -y retroarch
  
  install_switch_emulators
  install_playstation_emulators
  install_microsoft_emulators
}

install_ai_tools() {
  echo "Installing oterm (tui aichat)..."
  uv tool install oterm

  echo "Installing and configuring ollama..."
  curl -fsSL https://ollama.com/install.sh | sh

  echo "Setting up directories for ollama..."
  sudo mkdir -p /var/lib/ollama
  sudo chown -R ollama:ollama /var/lib/ollama
  sudo chmod 755 /var/lib/ollama

  echo "Enabling ollama service..."
  sudo systemctl enable --now ollama

  echo "Pulling models for ollama..."
  for model in 'gemma4:e4b' 'qwen3.5:9b' 'qwen3-embedding:8b'; do ollama pull "$model"; done
}

disable_sleep_hybernation() {
  echo "Disabling sleep and hybernation..."
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
}

main() {
  install_vpn 

  enable_packman_repo
  install_core_packages 
  enable_flatpak

  install_niri_dms
  install_syncthing 

  configure_tmux

  create_user_directories
  enable_snapper_home_snapshots

  if [[ $HOSTNAME == "desktop" ]]; then
    enable_virtualization 
    enable_docker
    install_nvidia_drivers
    install_gaming_software
    disable_sleep_hybernation
  fi

  cleanup 
}

main
