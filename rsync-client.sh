#!/bin/bash
set -e

while [ true ]
do
    rsync --archive --delete --verbose --exclude-from=/etc/rsync-exclude.txt rsync://$1/wordpress-master/ /var/www/html
    sleep 10
done