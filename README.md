# My chezmoi dotfiles

## Installation

Install this with `cz init ${this repo url}`

Change shell to zsh: `chsh -s /bin/zsh`

Activate pacman postinstall [hook](etc/pacman.d/hooks/pkglist.hook) that updates `~/.pkglist` after each package install

## set last wallpaper

`set_wallpaper.sh $(cat ~/.wallpaper.url)`
