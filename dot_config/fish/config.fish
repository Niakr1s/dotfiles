source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # smth smth
end

fish_add_path ~/.local/bin

alias vim "nvim"
export EDITOR=nvim

export FZF_DEFAULT_COMMAND="fd --type f --hidden --ignore .git"
export v2rayn_proxy="127.0.0.1:10808"
