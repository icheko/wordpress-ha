#!/bin/bash
set -e

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
echo "[x] Delete wp-config.php"
rm -f wp-config.php

echo
echo ------------------------------------------------------
echo "[x] Calling base entrypoint with param: $@"
echo
docker-entrypoint.sh "$@"