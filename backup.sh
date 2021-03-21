echo "Starting backup"
backupPath=/home/steam/backups
#!/bin/bash

## Get the current date as variable.
TODAY="$(date +%Y-%m-%d)"

## Clean up files older than 2 weeks. Create a new backup.
find $backupPath -mtime +14 -type f -delete

systemctl stop valheimserver.service

#Wait for RAM to offload to .db and .db.old
#allows for the closing of the databases.
sleep 10

## Tar Section. Create a backup file, with the current date in its name.
## Add -h to convert the symbolic links into a regular files.
## Backup some system files, also the entire `/home` directory, etc.
## --exclude some directories, for example the the browser's cache, `.bash_history`, etc.
tar zcvf "$backupPath/valheim-backup-$TODAY.tgz" /home/steam/.config/unity3d/IronGate/Valheim/worlds/*
chown steam:steam $backupPath/valheim-backup-$TODAY.tgz
echo "Copy backup to remote"
rclone delete gdrive:valheim_backup/
rclone copy $backupPath/$(ls -Art $backupPath | tail -n 1) gdrive:valheim_backup/
rclone delete remote:/srv/data/valheim-backup/
rclone copy $backupPath/$(ls -Art $backupPath | tail -n 1) remote:/srv/data/valheim-backup/
echo "Done"

systemctl start valheimserver.service
