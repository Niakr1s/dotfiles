# My chezmoi dotfiles

## `~/pkglist.txt` explanation

This updates every time via pacman post install hook. You should create one at `/etc/pacman.d/hooks/pkglist.hook` with contents:

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
