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
    echo -e "\t-r <path/to/restore/directory>: sets restore directory"
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
restore_dir=""
dry_run=""
logfile="/tmp/backup-system.log"
yes=""

while getopts 'b:r:l:dy' flag; do
  case "${flag}" in
    b) backup_dir="${OPTARG}"
       if [[ $backup_dir == "" ]]
       then
           echo "No backup directory provided"
           usage
           exit 1
       fi
       if [[ $backup_dir != */ ]]
       then
           backup_dir+="/"
       fi
       mkdir -p $backup_dir
       ;;
    r) restore_dir="${OPTARG}" 
       if [[ $restore_dir == "" ]]
       then
           echo "No restore directory provided"
           usage
           exit 1
       fi
       if [[ $restore_dir != */ ]]
       then
           restore_dir+="/"
       fi
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

echo "Provided arguments:"
echo -e "\tBackup directory: '$backup_dir'"
echo -e "\tRestore directory: $restore_dir"
echo -e "\tLog file path: '$logfile'"
echo -e "\tDry run: '$dry_run'"
echo

if [[ $restore_dir == "" ]]
then
    action="BACKUP"
    from="/"
    to=$backup_dir
    echo "You are in BACKUP mode."
    echo "Warning: your backup directory ($to) shouldn't be inside your source directory ($from), otherwise you'll find yourself stuck in an endless loop."
    echo "Consider using external drive and mounting it to '/mnt/backup'. It is safe because whole '/mnt' directory is excluded from backup."
else
    action="RESTORE"
    from=$backup_dir
    to=$restore_dir
    echo "You are in RESTORE mode."
    echo "It's not supposed to be run from running system. You probably want to boot from live cd to restore."
    echo "Warning: your restore directory ($to) shouldn't contain source directory ($from), otherwise you'll find yourself stuck in an endless loop."
    echo "ATTENTION: restore is not fully tested yet."
fi
echo

echo "Going to $action from '$from' to '$to'"
if [[ $yes == "" ]]
then
    yes_or_abort "Do you want to continue?"
fi

rsync -aAXHv --delete $dry_run --exclude={\
'dev/*',\
'proc/*',\
'sys/*',\
'tmp/*',\
'run/*',\
'mnt/**/*',\
'media/*',\
'lost+found',\
'home/**/.cache'\
} $from $to 2>&1 | tee $logfile

echo "All done. Log file: $logfile"
