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

## Additional configuration

### Mounting NTFS volumes

1. To aquire UUID of a volume run `lsblk -f`.

1. Add mounting points.

```bash
sudo mkdir /mnt/c
sudo mkdir /mnt/d
sudo chown $USER:$USER /mnt/c
sudo chown $USER:$USER /mnt/d
```

1. Update `/etc/fstab`.

Flags description:

- defaults: defaults (see `man mount`)
- uid: set owner user to `id -u` output
- gid: set owner group to `id -g` output
- umask: set to 077 if we want to be the only owner of a mounted volume
- utf8: for filename resolving
- 2: used for priority of fschk, should be set to 2 for non-root partition
- ro: read only for volume with windows

```fstab
UUID="c_disk_uuid" /mnt/c ntfs defaults,uid=1000,gid=1000,umask=077,utf8,ro 0 2
UUID="d_disk_uuid" /mnt/d ntfs defaults,uid=1000,gid=1000,umask=077,utf8    0 2
```
