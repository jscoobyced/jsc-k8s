#!/bin/ash

FILENAME=$(date '+%Y%m%d-%H%M%S')

mysqldump -h narok-wp-mariadb -unarok-wp-user -p"<NAROK WP PASSWORD>" narok-wp-db > /data/narok-wp-${FILENAME}.sql
gzip /data/narok-wp-${FILENAME}.sql

mysqldump -h hdc-wp-mariadb -uhdc-wp-user -p"<HDC WP PASSWORD>" hdc-wp-db > /data/hdc-wp-${FILENAME}.sql
gzip /data/hdc-wp-${FILENAME}.sql