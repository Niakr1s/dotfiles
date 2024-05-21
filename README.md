# Dotfiles for my void linux installation

## Installation

### Void Linux

#### Fresh install

- Ensure that you've cloned dotfiles:

```sh
sudo xbps-install yadm
yadm clone https://github.com/niakr1s/dotfiles
yadm checkout ~
```

- Run install script:

```sh
~/.dotfiles/void-fresh-install.sh
```

#### Additional scripts

- `.dotfiles/void-configure-fonts.sh`: Fixes font hinting defaults in fresh
void linux installation.

- `.dotfiles/void-install-portproton.sh`: Installs portproton with all dependencies.
