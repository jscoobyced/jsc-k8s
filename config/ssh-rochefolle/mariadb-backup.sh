#!/bin/ash

FILENAME=$(date '+%Y%m%d-%H%M%S')

if [ ! -d ~/.config/rclone ];
then
    mkdir -p ~/.config/rclone/
    cp /data/.config/rclone/rclone.conf ~/.config/rclone/rclone.conf
fi

mysqldump -h narok-wp-mariadb -unarok-wp-user -p"<NAROK WP PASSWORD>" narok-wp-db > /data/narok-wp-${FILENAME}.sql
gzip /data/narok-wp-${FILENAME}.sql
rclone move /data/narok-wp-${FILENAME}.sql.gz dropbox:backup/narokio/

mysqldump -h hdc-wp-mariadb -uhdc-wp-user -p"<HDC WP PASSWORD>" hdc-wp-db > /data/hdc-wp-${FILENAME}.sql
gzip /data/hdc-wp-${FILENAME}.sql
rclone move /data/hdc-wp-${FILENAME}.sql.gz dropbox:backup/himdome/
