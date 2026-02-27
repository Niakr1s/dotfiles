source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
function fish_greeting
    # smth smth
end


# ALIASES

alias logout "hyprctl dispatch exit"
alias cz "chezmoi"


# CORE

set EDITOR vim
set TERMINAL kitty
set TERM kitty


# FZF

set FZF_DEFAULT_COMMAND "fd --type f --hidden --exclude .git --exclude dosdevices --exclude drive_c"
set FZF_CTRL_T_OPTS "
  --walker-skip .git,node_modules,target,dosdevices,drive_c
  --preview 'bat -n --color=always {}'
"
# CTRL-Y to copy the command into clipboard using pbcopy
set FZF_CTRL_R_OPTS "
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'
"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,dosdevices,drive_c
  --preview 'tree -C {}'"


# PROXY

set v2rayn_proxy "127.0.0.1:10808"
set http_proxy "http://$v2rayn_proxy"
set https_proxy "http://$v2rayn_proxy"
set no_proxy "localhost,127.0.0.1"
