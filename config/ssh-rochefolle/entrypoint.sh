#!/bin/sh

# Setup and start cron
touch /var/log/cron.log
chmod o+r /var/log/cron.log
crond -l 2 -L /var/log/cron.log

# Setup and mount dropbox with rclone
su-exec jscoobyced cp -r /data/.config /home/jscoobyced
rclone mount --daemon dropbox: /data/dropbox

# Ensure backup script has password
NOPASSWD=$(grep "WP PASSWORD" /home/jscoobyced/bin/mariadb-backup.sh | wc -l)

if [ "${NOPASSWD}" != "0" ];
then
    su-exec jscoobyced cp /data/mariadb-backup.sh /home/jscoobyced/bin/
fi    

# Setup and start SSH
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"