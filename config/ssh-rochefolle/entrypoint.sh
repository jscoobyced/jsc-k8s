#!/bin/sh

touch /var/log/cron.log
chmod o+r /var/log/cron.log
crond -l 2 -L /var/log/cron.log

ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"