#!/bin/bash
set -e
user="$(id -u)"
group="$(id -g)"

echo
echo ------------------------------------------------------
echo "[x] Starting container in ${CONTAINER_MODE} mode"
echo "[x] Running as user ${user} - group ${group}"

echo
echo ------------------------------------------------------
echo "[x] Write supervisor configs"
echo
env | j2 --format=env ${SUPERVISOR_ADDL_CONFIGS}/apache-server.tpl > ${SUPERVISOR_ADDL_CONFIGS}/apache-server.conf

if [ "$CONTAINER_MODE" = "slave" ]; then
    env | j2 --format=env ${SUPERVISOR_ADDL_CONFIGS}/rsync-client.tpl > ${SUPERVISOR_ADDL_CONFIGS}/rsync-client.conf
else
    env | j2 --format=env ${SUPERVISOR_ADDL_CONFIGS}/rsync-server.tpl > ${SUPERVISOR_ADDL_CONFIGS}/rsync-server.conf
fi

echo
echo ------------------------------------------------------
echo "[x] Rewrite wp-config.php"
rm -f wp-config.php

if [ "$CONTAINER_MODE" = "slave" ]; then
    echo
    echo Additional Security Measures
    echo ------------------------------------------------------
    echo "[x] Overwrite root htaccess"
    cp ../apache-slave.htaccess .htaccess
    chown "$user:$group" .htaccess

    if [ -d "wp-admin" ]; then
        echo "[x] Deny access to wp-admin"
        echo "Deny from all" > wp-admin/.htaccess
        chown "$user:$group" wp-admin/.htaccess
    fi

    echo "[x] Delete wp-login.php"
    rm -f wp-login.php
fi

echo
echo ------------------------------------------------------
echo "[x] Calling base entrypoint with param: $@"
echo
docker-entrypoint.sh "$@"