#!/bin/ash

VERSION=$(date '+%Y%m%d-%H%M%S')
DROPBOX=/data/dropbox/backup
NAROK=${DROPBOX}/narokio
HDC=${DROPBOX}/himdome

mkdir -p ${NAROK}
mkdir -p ${HDC}

find ${NAROK}/* -mtime +31 -exec rm {} \;
find ${HDC}/* -mtime +31 -exec rm {} \;

mysqldump -h narok-wp-mariadb -unarok-wp-user -p"<NAROK WP PASSWORD>" narok-wp-db > /data/narok-wp-${VERSION}.sql
gzip /data/narok-wp-${VERSION}.sql
mv /data/narok-wp-${VERSION}.sql.gz ${NAROK}

mysqldump -h hdc-wp-mariadb -uhdc-wp-user -p"<HDC WP PASSWORD>" hdc-wp-db > /data/hdc-wp-${VERSION}.sql
gzip /data/hdc-wp-${VERSION}.sql
mv /data/hdc-wp-${VERSION}.sql.gz ${HDC}
