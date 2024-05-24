#!/bin/bash

check_su()
{
    if [ $(id -u) -ne 0 ]
    then
	    echo "Please run this script with sudo."
	    exit 1
    fi
}
check_su

usage()
{
    echo -e "Script that backups full system."
    echo -e "Flags:"
    echo -e "\t-b <path/to/backup/directory>: sets backup directory (required)"
    echo -e "\t-l <path/to/logfile>: set log file locaton"
    echo -e "\t-d: turn on dry run"
    echo -e "\t-y: answer yes to all prompts"
}

function yes_or_abort {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return ;;  
            [Nn]*) echo "Aborted" ; exit 1 ;;
        esac
    done
}

backup_dir=""
dry_run=""
logfile="/tmp/backup-system.log"
yes=""

while getopts 'b:l:dy' flag; do
  case "${flag}" in
    b) backup_dir="${OPTARG}"
       mkdir -p $backup_dir
       ;;
    l) logfile="${OPTARG}" 
       ;;
    d) dry_run="--dry-run"
       ;;
    y) yes="true"
       ;;
    *) usage
       exit 1 
       ;;
  esac
done

if [[ $backup_dir == "" ]]
then
    echo "No output directory provided"
    usage
    exit 1
fi

echo "Provided arguments:"
echo -e "\tBackup directory: $backup_dir"
echo -e "\tLog file path: $logfile"
echo -e "\tDry run: $dry_run"

from="/"

if [[ $yes == "" ]]
then
    yes_or_abort "Do you want to start backup?"
fi

rsync -aAXHv --delete $dry_run --exclude={\
'/dev/*',\
'/proc/*',\
'/sys/*',\
'/tmp/*',\
'/run/*',\
'/mnt/**/*',\
'/media/*',\
'lost+found',\
'/home/**/.cache',\
'$backup_dir',\
} / $backup_dir 2>&1 | tee $logfile

echo "All done. Log file: $logfile"
