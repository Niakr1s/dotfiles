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
    echo -e "\t-o <path/to/backup>: sets output directory (required)"
    echo -e "\t-l <path/to/logfile>: set log file locaton"
    echo -e "\t-d: turn on dry run"
    echo -e "\t-y: answer yes to all prompts"
}

function yes_or_abort {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) ;;  
            [Nn]*) echo "Aborted" ; exit  1 ;;
        esac
    done
}

output_dir=""
dry_run=""
logfile="/tmp/backup-system.log"
yes=""

while getopts 'o:l:dy' flag; do
  case "${flag}" in
    o) output_dir="${OPTARG}"
       mkdir -p $output_dir
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

if [[ $output_dir == "" ]]
then
    echo "No output directory provided"
    usage
    exit 1
fi

echo "Provided arguments:"
echo -e "\tOutput directory: $output_dir"
echo -e "\tLog file path: $logfile"
echo -e "\tDry run: $dry_run"

if [[ $yes == "" ]]
then
    yes_or_abort "Do you want to start backup?"
fi

rsync -aAXHv --delete --exclude={'/dev/*','/proc/*','/sys/*','/tmp/*','/run/*','/mnt/*','/media/*','lost+found','/home/**/.cache','$backup_dir',} / $dry_run $output_dir 2>&1 | tee $logfile

echo "All done. Log file: $logfile"
