backupPath=/home/steam/backups
echo "Starting backup"
printf '2\n1\ny\n0\n0\n' | ./menu.sh
echo "Copy backup to remote"
rclone delete gdrive:valheim_backup/
rclone copy $backupPath/$(ls -Art $backupPath | tail -n 1) gdrive:valheim_backup/
rclone delete remote:/srv/data/valheim-backup/
rclone copy $backupPath/$(ls -Art $backupPath | tail -n 1) remote:/srv/data/valheim-backup/
echo "Done"
