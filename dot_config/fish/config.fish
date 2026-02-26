source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # smth smth
end

set EDITOR nvim
set TERMINAL kitty
set TERM kitty
set FZF_DEFAULT_COMMAND "fd --type f --hidden --exclude .git --exclude dosdevices --exclude drive_c"
set v2rayn_proxy "127.0.0.1:10808"

alias vim "nvim"
alias vimdiff "nvim -d"
alias logout "hyprctl dispatch exit"
alias cz "chezmoi"
