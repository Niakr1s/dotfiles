#!/bin/bash

restic --one-file-system --exclude-caches --exclude-file=/home/nea/.dotfiles/backup_exclude_dirs.txt -r /mnt/backup backup / 
