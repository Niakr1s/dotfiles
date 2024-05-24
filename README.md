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

- defaults: see `man mount`
- uid: see `id -u`
- gid: see `id -g`
- umask: 077 = no access for other users
- utf8: for filename resolving
- ro: read only for volume with windows
- 2: used for priority of fschk, should be set to 2 for non-root partition

```fstab
UUID="c_disk_uuid" /mnt/c ntfs defaults,uid=1000,gid=1000,umask=077,utf8,ro 0 2
UUID="d_disk_uuid" /mnt/d ntfs defaults,uid=1000,gid=1000,umask=077,utf8    0 2
```

## Backup

There is a script [backup-system](.dotfiles/backup-system.sh) that handles the system backup.
It uses `rsync` under the hood. It backups the whole root system with some sane filtering.
Backups are made incrementally. Backup directory will be in full sync with root directory.
It means that if you delete a file since last backup, it will be removed in backup directory as well.

Example usage:

```bash
sudo backup-system -o /mnt/backup/
```

### Backuping to a file

Imagine you have a ntfs drive mounted at /mnt/d.
There are problems with permissions and other stuff when you try to backup ext4 to ntfs.
Therefore, we will backup system to a file.

First, create a blank non-sparce file (in this example it will be 30GB) and format it in ext4:

```bash
dd if=/dev/zero of=backup.img bs=1G count=30
mkfs.ext4 backup.img
```

Then, mount it:

```bash
mount backup.img /mnt/backup
```

After doing this, you can backup at `/mnt/backup`!

If needed, you can resize this file:

```bash
resize2fs backup.img 40G
```
