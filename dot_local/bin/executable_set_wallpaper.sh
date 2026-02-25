#!/bin/bash
## ---------------------------------------------------------------------------------- ##
## Sets random image as wallpaper, trying remote url, local folder and fallback       ##
## image. Then using executor like hyprpaper, feh, betterlockscreen or just prints     ##
## found image to the output.                                                         ##
## ---------------------------------------------------------------------------------- ##
## https://gist.github.com/onjin/411d7f9c6ebcaf66aa75abe6941bea55
## ---------------------------------------------------------------------------------- ##

## Example usage
#
## ❯ set_wallpaper.sh \
##    --url https://minimalistic-wallpaper.demolab.com/?random \
##    --dir ~/dotfiles/assets/wallpapers/ \
##    --fallback ~/dotfiles/assets/background.jpg \
##    --executor hyprpaper \
##    --verbose

## verbose output (if -v | --verbose is set):
## [find] using https://minimalistic-wallpaper.demolab.com/?random
## [found] /tmp/download_online_wallpaper.png
## [set] using hyprpaper

## ❯ set_wallpaper.sh -h
## Usage: set_wallpaper.sh [-u | --url] [-d | --dir] [-f | --fallback] [-e | --executor]
##       -u | --url [url]       -- url to download wallpaper from
##       -d | --dir [path]      -- path to directory to choose random wallpaper from
##       -f | --fallback [path] -- path to fallback image if no url/dir wallpaper is available
##       -e | --executor [name] -- executor to set image; default hyprpaper or feh depending on XDG_SESSION_TYPE
##       -v | --verbose         -- prints debug info to /dev/stderr - will not broke '--executor output'
##       -b | --browse          -- use with --dir to browse and set image; if 'sxiv' is available press 'm' to mark image and 'q' to quit preview and set
##       -l | --last            -- use last used wallpaper; saved at /home/onjin/.cache/set_wallpaper/last.jpg|png
##       -s | --save [path]     -- change save path from /home/onjin/.cache/set_wallpaper/ to another one; used with '--last-saved'
##
## Supported executors:
##  - hyprpaper                 -- creates ~/.config/hypr/hyprpaper.conf and restarts hyprpaper
##  - feh                       -- runs feh --bg-scale
##  - betterlockscreen          -- refreshes cache and runs betterlockscreen -w
##  - output                    -- prints wallpaper path to output

## ---------------------------------------------------------------------------------- ##
## ------------------------- Helper functions --------------------------------------- ##
## ---------------------------------------------------------------------------------- ##
function set_from_remote() {
    URL=$1
    JPG_FILE=/tmp/download_online_wallpaper.jpg
    PNG_FILE=/tmp/download_online_wallpaper.png

    curl -s "$URL" > $JPG_FILE

    if [[ $(file $JPG_FILE | grep -q "ASCII text") ]]; then
        echo ""
        exit 0
    fi
    wallpaper=$JPG_FILE
    if [[ $(file "$wallpaper" | grep  PNG) ]];  then
        mv $JPG_FILE $PNG_FILE
        wallpaper=$PNG_FILE
    fi
    echo "$wallpaper"

}

function set_from_folder() {
    FOLDER=$1
    wallpaper=$(find "$FOLDER" -type f | shuf --random-source=/dev/urandom -n 1)
    if [[ -z $wallpaper ]]; then
        echo ""
        exit 0
    fi
    echo "$wallpaper"
}

function notify() {
    MSG=$1
    if command -v notify-send &> /dev/null
    then
        notify-send "Wallpaper set" "$MSG"
    fi
}


function usage() {
    echo "Usage: $0"
}

## ---------------------------------------------------------------------------------- ##
## ------------------------- Main code ---------------------------------------------- ##
## ---------------------------------------------------------------------------------- ##
SHORT=d:,e:,f:,u:,s:,v,b,l,h
LONG=dir:,executor:,fallback:,url:,save:,verbose,browse,last,help
OPTS=$(getopt --alternative --name "$0" --options $SHORT --longoptions $LONG -- "$@")

eval set -- "$OPTS"

function usage() {
    echo "Usage: $0 [-u | --url] [-d | --dir] [-f | --fallback] [-e | --executor]"
    echo "      -u | --url [url]       -- url to download wallpaper from"
    echo "      -d | --dir [path]      -- path to directory to choose random wallpaper from"
    echo "      -f | --fallback [path] -- path to fallback image if no url/dir wallpaper is available"
    echo "      -e | --executor [name] -- executor to set image; default hyprpaper or feh depending on XDG_SESSION_TYPE"
    echo "      -v | --verbose         -- prints debug info to /dev/stderr - will not broke '--executor output'"
    echo "      -b | --browse          -- use with --dir to browse and set image; if 'sxiv' is available press 'm' to mark image and 'q' to quit preview and set"
    echo "      -l | --last            -- use last used wallpaper; saved at $XDG_CACHE_HOME/set_wallpaper/last.jpg|png"
    echo "      -s | --save [path]     -- change save path from $XDG_CACHE_HOME/set_wallpaper/ to another one; used with '--last-saved'"
    echo ""
    echo "Supported executors:"
    echo " - hyprpaper                 -- creates ~/.config/hypr/hyprpaper.conf and restarts hyprpaper"
    echo " - feh                       -- runs feh --bg-scale"
    echo " - betterlockscreen          -- refreshes cache and runs betterlockscreen -w"
    echo " - output                    -- prints wallpaper path to output"
}

FOLDER=
FALLBACK=
URL=
VERBOSE=0
BROWSE=0
USE_LAST=0
SAVE_PATH=${XDG_CACHE_HOME:-$HOME/.cache}/set_wallpaper

mkdir -p "${SAVE_PATH}"

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    EXECUTOR=hyprpaper
else
    EXECUTOR=feh
fi

while :
do
  case "$1" in
    -d | --dir )
      FOLDER="$2"
      shift 2
      ;;
    -e | --executor )
      EXECUTOR="$2"
      shift 2
      ;;
    -f | --fallback )
      FALLBACK="$2"
      shift 2
      ;;
    -s | --save )
      SAVE_PATH="$2"
      shift 2
      ;;
    -u | --url )
      URL="$2"
      shift 2
      ;;
    -v | --verbose )
      VERBOSE=1
      shift 1
      ;;
    -b | --browse )
      BROWSE=1
      shift 1
      ;;
    -l | --last )
      USE_LAST=1
      shift 1
      ;;
    -h | --help)
      usage
      exit 2
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      ;;
  esac
done

function debug() { if [[ $VERBOSE == "1" ]]; then echo "$1" > /dev/stderr; fi; }
function error() { debug "$1"; exit 1; }

## ---------------------------------------------------------------------------------- ##
## ------------------------- Find wallpaper to set ---------------------------------- ##
## ---------------------------------------------------------------------------------- ##
source=""
wallpaper=""

# 0. try to use last wallpaper
if [[ ${USE_LAST} == "1" ]]; then
    wallpaper=$(find "${SAVE_PATH}" -name 'last.*')
    if [[ -n "${wallpaper}" ]]; then
        source='last'
        debug "[last] using last wallpaper $wallpaper"
    else
        debug "[skip] there is no last wallpaper saved, proceeding"
    fi
fi

# 1. try to download wallpaper -- -u | --url
if [[ -z $wallpaper ]]; then
    if [[ -n $URL ]]; then
        source=$URL
        debug "[find] using $URL"
        wallpaper=$(set_from_remote $URL)
    else
        debug "[skip] use -u | --url to download wallpaper from url"
    fi
fi

# 2. try to get random image from folder -- -d | --url
if [[ -z $wallpaper ]]; then
    if [[ -n $FOLDER ]]; then
        source=$FOLDER
        debug "[find] using folder $FOLDER"
        # browse mode

        if [[ $BROWSE == 1 ]]; then
            if [[ -z $FOLDER ]]; then
                usage
                exit 0
            fi
            if command -v "sxiv" &> /dev/null
            then
                wallpaper=$(sxiv -t -o -r $FOLDER)
            else
                wallpaper=$(find $FOLDER | rofi -dmenu -show-icons)
            fi
        else
            wallpaper=$(set_from_folder "$FOLDER")
        fi
    else
        debug "[skip] use -d | --dir to choose wallpaper from folder"
    fi
fi

# 3. try to set fallback image -- -f | --fallback
if [[ -z $wallpaper ]]; then
    if [[ -n $FALLBACK ]]; then
        debug "[find] using fallback $FALLBACK"
        source=$FALLBACK
        wallpaper=$FALLBACK
    else
        debug "[skip] use -f | --fallback to set given image as wallpaper"
    fi
fi

if [[ -z $wallpaper ]]; then
    debug "[find] ¯\(ツ)/¯ cannot set any wallpaper"
    notify "¯\(ツ)/¯ cannot set any wallpaper"
    exit 1
fi

debug "[found] $wallpaper"

# 3.a. save last used wallpaper
if [[ $source != "last" ]]; then
    extension="${wallpaper##*.}"
    saved="${SAVE_PATH}/last.${extension}"
    rm -f "${SAVE_PATH}"/last.*  ## clean old wallpapers
    cp -f "$wallpaper" "${saved}"
    debug "[save] saved image to ${saved}"
else
    debug "[skip] do not save again last used wallpaper"
fi

# 4. set wallpaper using executor -- -e | --executor

if [[ $EXECUTOR == "output" ]]; then
    echo $wallpaper
    exit 0
fi

debug "[set] using $EXECUTOR"
if ! command -v "$EXECUTOR" &> /dev/null
then
    error "[set] executor $EXECUTOR not found :/"
fi

if [[ $EXECUTOR == "hyprpaper" ]]; then
    # echo -ne "preload = $wallpaper \nwallpaper = ,$wallpaper" > ~/.config/hypr/hyprpaper.conf
    echo -ne "wallpaper {\n  monitor = \n  fit_mode = cover\n  path = $wallpaper\n}" > ~/.config/hypr/hyprpaper.conf
    killall hyprpaper
    sleep 2
    hyprpaper > /dev/null 2>&1 &

    notify "[$source] $wallpaper"
    exit 0
fi

if [[ $EXECUTOR == "feh" ]]; then
    feh --bg-scale "$wallpaper"

    notify "[$source] $wallpaper"
    exit 0
fi

if [[ $EXECUTOR == "betterlockscreen" ]]; then
    debug "[betterlockscreen] updating cache ..."
    betterlockscreen -u "$wallpaper"
    debug "[betterlockscreen] setting wallpaper"
    betterlockscreen -w

    notify "[$source] $wallpaper"
    exit 0
fi

notify "executor $EXECUTOR not supported :/"
error "[set] executor $EXECUTOR not supported :/"
