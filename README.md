# Dotfiles for my *Void Linux* installation

## Installation

First of all you should clone this repo using `yadm` dotfile manager.
You can achieve this with [clone.sh](.dotfiles/clone.sh) script.

It can be run without actually saving it:

```bash
`wget https://github.com/Niakr1s/dotfiles/raw/main/.dotfiles/clone.sh -O- | bash`
```

There are several scripts used for fresh installation.
You can run them in a such order:

1. [void-fresh-install.sh](.dotfiles/void-fresh-install.sh):
Installs configuration files at freshly installed void linux.
You should clone this repository first.
Consider using `.dotfiles/clone.sh` script.

1. [void-configure-fonts.sh](.dotfiles/void-configure-fonts.sh):
Fixes font hinting defaults in fresh void linux installation.

1. [void-install-portproton](.dotfiles/void-install-portproton.sh):
Installs portproton with all dependencies.
