# Dotfiles for my void linux installation

## Installation

### Void Linux

There are several scripts used for fresh void linux installation:

1. `.dotfiles/clone.sh`:
Clones this repository with `yadm` dotfile manager.
Can be run using following command without actually saving it:
`wget https://github.com/Niakr1s/dotfiles/raw/main/.dotfiles/clone.sh -O- | bash`

1. `.dotfiles/void-fresh-install.sh`:
Installs configuration files at freshly installed void linux.
You should clone this repository first.
Consider using `.dotfiles/clone.sh` script.

1. `.dotfiles/void-configure-fonts.sh`:
Fixes font hinting defaults in fresh void linux installation.

1. `.dotfiles/void-install-portproton.sh`:
Installs portproton with all dependencies.
