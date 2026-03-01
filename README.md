# My chezmoi dotfiles

## Installation

Install this with `cz init ${this repo url}`

### `~/pkglist.txt` pacman postinstall hook

Create a file `/etc/pacman.d/hooks/pkglist.hook` with contents:

```
[Trigger]
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
When = PostTransaction
Exec = /bin/sh -c '/usr/bin/pacman -Qqe > /home/nea/pkglist.txt'
```

I have desktop and laptop, and it for sure bloats my laptop with extra packages from desktop, maybe I should think about doing it so bluntly, but it's okay for now.

## set last wallpaper

`set_wallpaper.sh $(cat ~/.wallpaper.url)`
