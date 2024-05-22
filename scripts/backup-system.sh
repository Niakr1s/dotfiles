#!/bin/sh

usage()
{
    echo "Script that backups full system."
    echo -e "Usage:\n\t$0 /path/to/backup"
}

if [ $# -ne 1 ]
then
    usage
    exit 1
fi

backup_dir=$1

mkdir -p $backup_dir

echo "Starting backup..."
backup_cmd="sudo rsync -aAXHv / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","$backup_dir"} $backup_dir"

echo $backup_cmd
$backup_cmd
